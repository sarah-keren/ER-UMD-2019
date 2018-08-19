#include <cerrno>
#include <chrono>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <iostream>
#include <signal.h>
#include <sstream>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include "../../include/ppddl/PPDDLProblem.h"
#include "../../include/ppddl/mini-gpt/problems.h"
#include "../../include/reduced/ReducedModel.h"
#include "../../include/reduced/ReducedState.h"
#include "../../include/solvers/FFReducedModelSolver.h"


using namespace mlcore;
using namespace mlppddl;
using namespace std;


// Handler for the child process running FF
static void sigchld_hdl(int sig)
{
    // the main process will handle the child, no need to do anything
}


namespace mlsolvers
{

void FFReducedModelSolver::storeRemovedInitAtoms()
{
    mlreduced::ReducedModel* reducedModel =
        dynamic_cast<mlreduced::ReducedModel*> (problem_);
    assert(reducedModel);
    mlppddl::PPDDLProblem* originalProblem =
        dynamic_cast<mlppddl::PPDDLProblem*> (reducedModel->originalProblem());
    assert(originalProblem);

    // Storing all atoms in the initial state
    ifstream problemTemplateFile_;
    problemTemplateFile_.open(templateProblemFilename_, ifstream::in);
    string line;
    unordered_set<string> initAtoms;
    if (problemTemplateFile_.is_open()) {
        while (getline(problemTemplateFile_, line)) {
            size_t idx = line.find("init");
            if (idx != string::npos) {
                for (int i = idx + 4; i < line.size(); i++) {
                    if (line[i] == '(') {
                        string atom = "";
                        do {
                            atom += line[i];
                        } while (line[i++] != ')');
                        initAtoms.insert(atom);
                        i--;
                    }
                }
            }
        }
        problemTemplateFile_.close();
    }

    // Figuring out which atoms were removed from the PPDDL parser
    problem_t* pProblem = originalProblem->pProblem();
    Domain dom = pProblem->domain();
    PredicateTable& preds = dom.predicates();
    TermTable& terms = pProblem->terms();
    for (auto const & atom : problem_t::atom_hash()) {
        ostringstream oss;
        atom.first->print(oss, preds, dom.functions(), terms);
        if (initAtoms.find(oss.str()) != initAtoms.end())
            initAtoms.erase(oss.str());
    }

    // Storing the removed atoms
    removedInitAtoms_ = "";
    for (string atom : initAtoms)
        removedInitAtoms_ += atom + " ";
}


string FFReducedModelSolver::extractStateAtoms(PPDDLState* state)
{
    ostringstream oss;
    oss << state;
    string stateStr = oss.str();
    string atomsCurrentState = "";
    for (int i = 0; i < stateStr.size(); i++) {
        // The format of a PPDDLState "tostring" conversion is
        // [ atom_1_Id:(atom_1), atom_2_Id:(atom_2), ..., atom_N_Id:(atom_N) ]
        if (stateStr[i] == ':') {
            i++;
            do {
                atomsCurrentState += stateStr[i];
            } while (stateStr[i++] != ')');
            atomsCurrentState += " ";
        }
    }
    return atomsCurrentState;
}


void FFReducedModelSolver::replaceInitStateInProblemFile(
    string atomsCurrentState)
{
    ifstream problemTemplateFile_;
    problemTemplateFile_.open(templateProblemFilename_, ifstream::in);
    string line;
    string newProblemText = "";
    if (problemTemplateFile_.is_open()) {
        while (getline(problemTemplateFile_, line)) {
            if (line.find("init") != string::npos) {
                line = "(:init " + removedInitAtoms_ + atomsCurrentState + ")";
            }
            newProblemText += line + "\n";
        }
        problemTemplateFile_.close();
    }
    ofstream newProblemFile;
    newProblemFile.open(currentProblemFilename_);
    newProblemFile << newProblemText;
    newProblemFile.close();
}


pair<string, int> FFReducedModelSolver::getActionNameAndCostFromFF()
{
    pid_t child_pid;
    int fds[2];
    int pipe_ret = pipe(fds);
    if (pipe_ret != 0) {
        cerr << "Error creating pipe for FF: " << strerror(errno) << endl;
        exit(-1);
    }

    string actionName = "__mdplib-dead-end__";
    int costFF = floor(mdplib::dead_end_cost);
    time_t timeLeft = 0.0;
    if (planningTimeHasRunOut(&timeLeft)) {
        return make_pair(actionName, costFF);
    }

    // setting a handler for the FF child process
    struct sigaction act;
	memset (&act, 0, sizeof(act));
	act.sa_handler = sigchld_hdl;
	if (sigaction(SIGCHLD, &act, 0) == -1) {
		cerr << "Error setting handler for FF process signal" << endl;
		exit(-1);
	}

    child_pid = fork();
    if (child_pid != 0) {   // parent process (process FF output)
        close(fds[1]);
        int status;
        while (timeLeft > 0) {  // TODO: improve this ugly code hack
            planningTimeHasRunOut(&timeLeft);
            pid_t wait_result = waitpid(child_pid, &status, WNOHANG);
            if (wait_result == -1) {
                cerr << "Error ocurred during call to FF: " <<
                    strerror(errno) << endl;
                exit(-1);
            } else if (wait_result == 0) {  // FF still running
                this_thread::sleep_for(chrono::milliseconds(1000));
            } else {    // FF finished
                break;
            }
        }
        kill(child_pid, SIGTERM); // seems to be safe to use on child processes
        pid_t wait_result = waitpid(child_pid, &status, 0);
        FILE* ff_output = fdopen(fds[0], "r");
        if (ff_output) {
            char lineBuffer[1024];
            int currentLineAction = -1;
            while (fgets(lineBuffer, 1024, ff_output)) {
                if (strstr(lineBuffer, "goal can be simplified to FALSE.") !=
                        nullptr) {
                    break;
                }
                if (strstr(lineBuffer, "step") != nullptr) {
                    actionName = "";
                    char *pch = strstr(lineBuffer, "0:");
                    if (pch == nullptr)
                        continue;
                    pch += 3;
                    actionName += pch;
                    actionName = actionName.substr(0, actionName.size() - 1);
                    currentLineAction = 0;
                } else if (currentLineAction != -1) {
                    currentLineAction++;
                    ostringstream oss("");
                    oss << currentLineAction << ":";
                    char *pch = strstr(lineBuffer, oss.str().c_str());
                    if (pch == nullptr) {
                        costFF = currentLineAction;
                        currentLineAction = -1;
                    }
                }
            }
            pclose(ff_output);
        } else {
            cerr << "Error reading the output of FF." << endl;
            exit(-1);
        }
        for (int i = 0; i < actionName.size(); i++) {
            actionName[i] = tolower(actionName[i]);
        }
        return make_pair(actionName, costFF);
    } else {    // child process (the one that calls FF)
        close(fds[0]);
        dup2(fds[1], STDOUT_FILENO);
        const char* ff_args[] = {
            "ff",
            "-o",
            determinizedDomainFilename_.c_str(),
            "-f",
            currentProblemFilename_.c_str(),
            NULL
        };
        execvp(ffExecFilename_.c_str(), const_cast<char**> (ff_args));
        cerr << "An error ocurred while calling FF: " <<
            strerror(errno) << endl;
        abort();
    }
}


mlcore::Action* FFReducedModelSolver::getActionFromName(string actionName)
{
    ostringstream oss;
    for (mlcore::Action* a : problem_->actions()) {
        oss.str("");
        oss.clear();
        oss << a;
        if (oss.str().find(actionName) != string::npos)
            return a;
    }
    return nullptr;
}


mlcore::Action* FFReducedModelSolver::solve(mlcore::State* s0)
{
    startingPlanningTime_ = time(nullptr);
    this->lao(s0);
    return s0->bestAction();
}


void FFReducedModelSolver::lao(mlcore::State* s0)
{
    // This is a stack based implementation of LAO*.
    // We don't use the existing library implementation because we are going to
    // solve the reduced states with j=k using FF.
    StateSet visited;
    int countExpanded = 0;
    while (true) {
        do {
            visited.clear();
            countExpanded = 0;
            list<mlcore::State*> stateStack;
            stateStack.push_back(s0);
            while (!stateStack.empty()) {
                if (planningTimeHasRunOut())
                    return;
                mlcore::State* s = stateStack.back();
                stateStack.pop_back();
                if (!visited.insert(s).second)  // state was already visited.
                    continue;
                if (s->deadEnd() || problem_->goal(s))
                    continue;
                int cnt = 0;
                if (s->bestAction() == nullptr) {
                    // state has never been expanded.
                    this->bellmanUpdate(s);
                    countExpanded++;
                    continue;
                } else {
                    mlcore::Action* a = s->bestAction();
                    for (Successor sccr : problem_->transition(s, a)) {
                        stateStack.push_back(sccr.su_state);
                    }
                }
                this->bellmanUpdate(s);
            }
        } while (countExpanded != 0);
        while (true) {
            visited.clear();
            list<mlcore::State*> stateStack;
            stateStack.push_back(s0);
            double error = 0.0;
            while (!stateStack.empty()) {
                if (planningTimeHasRunOut())
                    return;
                mlcore::State* s = stateStack.back();
                stateStack.pop_back();
                if (!visited.insert(s).second)
                    continue;
                if (s->deadEnd() || problem_->goal(s))
                    continue;
                mlcore::Action* prevAction = s->bestAction();
                if (prevAction == nullptr) {
                    // if it reaches this point it hasn't converged yet.
                    error = mdplib::dead_end_cost + 1;
                } else {
                    for (Successor sccr : problem_->transition(s, prevAction)) {
                        stateStack.push_back(sccr.su_state);
                    }
                }
                error = std::max(error, this->bellmanUpdate(s));
                if (prevAction != s->bestAction()) {
                    // it hasn't converged because the best action changed.
                    error = mdplib::dead_end_cost + 1;
                    break;
                }
            }
            if (error < epsilon_)
                return;
            if (error > mdplib::dead_end_cost) {
                break;  // BPSG changed, must expand tip nodes again
            }
        }
    }
}


double FFReducedModelSolver::bellmanUpdate(mlcore::State* s)
{
    if (problem_->goal(s)) {
        s->setCost(0.0);
        for (mlcore::Action* a : problem_->actions()) {
            if (problem_->applicable(s, a)) {
                s->setBestAction(a);
                return 0.0;
            }
        }
    }

    mlreduced::ReducedState* reducedState = (mlreduced::ReducedState* ) s;
    if (useFF_ && reducedState->exceptionCount() == maxHorizon_) {
        // For exceptionCount = k we just call FF.
        PPDDLState* pState =
            static_cast<PPDDLState*> (reducedState->originalState());
        string stateAtoms = extractStateAtoms(
            static_cast<PPDDLState*> (pState));
        replaceInitStateInProblemFile(stateAtoms);
        mlcore::Action* stateFFAction;
        int stateFFCost;
        if (ffStateActions_.count(s)) {
            stateFFAction = ffStateActions_[s];
            stateFFCost = ffStateCosts_[s];
        } else {
            pair<string, int> actionNameAndCost = getActionNameAndCostFromFF();

            // If FF finds this state is a dead-end,
            // getActionNameAndCostFromFF() returns "__mdplib-dead-end__"
            // and getActionFromName() returns a nullptr.
            stateFFAction = getActionFromName(actionNameAndCost.first);
            if (stateFFAction == nullptr) {
                s->markDeadEnd();
            }
            ffStateActions_[s] = stateFFAction;
            ffStateCosts_[s] = actionNameAndCost.second;
        }
        s->setCost(ffStateCosts_[s]);
        s->setBestAction(ffStateActions_[s]);
        return 0.0;
    }
    std::pair<double, mlcore::Action*> best = bellmanBackup(problem_, s);
    double residual = s->cost() - best.bb_cost;

    if (s->deadEnd()) {
        s->setCost(mdplib::dead_end_cost);
        return 0.0;
    }

    s->setCost(best.bb_cost);
    s->setBestAction(best.bb_action);
    return fabs(residual);
}


bool FFReducedModelSolver::planningTimeHasRunOut(time_t* timeLeft) {
    time_t elapsedTime = time(nullptr) - startingPlanningTime_;
    if (timeLeft != nullptr)
        *timeLeft = maxPlanningTime_ - elapsedTime;
    return elapsedTime > maxPlanningTime_;
}

}
