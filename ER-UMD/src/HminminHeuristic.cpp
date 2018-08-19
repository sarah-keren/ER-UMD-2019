#include<list>

#include "../include/HminminHeuristic.h"
#include "../include/solvers/Solver.h"
#include "../include/UmdUtils.h"

using namespace mlcore;


namespace umd
{


HminminHeuristic::HminminHeuristic(mlcore::Problem* problem, int iteration_limit,bool solveAll):MDPHeuristic()
{


    problem_ = (ErUmdProblem*)problem;

    this->iteration_limit = iteration_limit;
    /*
    solveAll_ = solveAll;
    if (solveAll_) {
        problem->generateAll();
        while (true) {


            double maxResidual = 0.0;
            for (State * s : problem->states()) {
                double prevCost = costs_[s];
                hminUpdate(s);
                maxResidual = std::max(maxResidual, fabs(costs_[s]- prevCost));
            }
            if (maxResidual < 1.0e-6)
                break;
        }
    }
    */
}



double HminminHeuristic::cost(const mlcore::State* s)
{

    //std::cout<<"Entering  hmin cost with state : "<< (mlcore::State*)s<< std::endl;
    this->update_counter(s);



    if (problem_->goal(const_cast<mlcore::State*>(s)))
    {
        //std::cout<<" ------->goal sate "<<std::endl;
        return 0.0;
    }

    //std::cout<<" ------->serching for precomputed value "<<std::endl;
    auto it = costs_.find(const_cast<mlcore::State*> (s));
    if (it != costs_.end())
    {
        //std::cout<<" ------->value found: "<<it->second<<std::endl;
        return it->second;
    }

    //std::cout<<"Value not in cache - computing  : "<< (mlcore::State*)s<< std::endl;

    // update the counter of nodes calculated fully
    this->update_counter_calculated(s);


    mlcore::State* currentState = nullptr;
    while (true) {

        // Starting a LRTA* trial.
        currentState = const_cast<mlcore::State*> (s);
        bool noActionChange = true;
        double maxResidual = 0.0;
        int counter = 0;
        // continue as long as the goal has not been reached
        while (!problem_->goal(currentState)) {

            //get the current best action
            mlcore::Action* bestAction = nullptr;
            if (bestActions_.count(currentState) > 0)
                bestAction = bestActions_[currentState];

            //update the value of the current state (and its best action)
            hminUpdate(currentState);

            //get the previous cost and check if the best action has changed
            double prevCost = costs_[currentState];
            if (currentState->deadEnd())
                break;
            if (bestAction != bestActions_.at(currentState))
                noActionChange = false;

            //check if the cost difference is meaningful
            maxResidual = std::max(maxResidual,
                                   fabs(prevCost - costs_.at(currentState)));


            // Getting the successor of the best action - and update their costs
            bestAction = bestActions_.at(currentState);
            double minCost = mdplib::dead_end_cost;
            mlcore::State* nextState = nullptr;
            for (auto const & successor :
                    problem_->transition(currentState, bestAction)) {

                double successorCost = costs_.at(successor.su_state);
                if (successorCost < minCost) {
                    nextState = successor.su_state;
                    minCost = successorCost;
                }
            }

            // change to the next state
            currentState = nextState;
            if (currentState == nullptr)
            {
                break;
            }
            //std::cout<<"current state is "<< (mlcore::State*)currentState<< " iteration:" << counter<< " and goal "<< problem_->goal(currentState)<<std::endl;
        }

        // if no action has been updated and there is no meaningful change - stop
        if (noActionChange && maxResidual < 1.0e-6)
            break;
    }


    it = costs_.find(const_cast<mlcore::State*> (s));
    //std::cout<< "\n cost::::: " << it->second << std::endl<<std::endl;
    //print_cost_array();


    return it->second;
}


void HminminHeuristic::hminUpdate(mlcore::State* s)
{
    //if the problem is the goal - the cost is 0
    if (problem_->goal(s)) {
        costs_[s] = 0.0;
        return;
    }

    //iterate through applicable actions and check if their value was updated (taking the min instead of expected value)
    double bestQ = mdplib::dead_end_cost;
    bool hasAction = false;
    for (mlcore::Action* a : problem_->actions()) {
        if (!problem_->applicable(s, a))
            continue;
        hasAction = true;
        double qAction = problem_->cost(s, a);
        //std::cout<<"In hmin update with state:" <<s <<" and action: " << a << " and cost:" <<qAction<<std::endl;
        double minCostSuccessor = mdplib::dead_end_cost;
        for (auto const & successor : problem_->transition(s, a)) {
            minCostSuccessor =
                std::min(minCostSuccessor, costs_[successor.su_state]);
        }
        qAction += minCostSuccessor;
        qAction = std::min(qAction, mdplib::dead_end_cost);
        if (qAction <= bestQ) {
            bestQ = qAction;
            bestActions_[s] = a;
        }
    }
    if (!hasAction) {
        s->markDeadEnd();
    }
    costs_[s] = bestQ;
}



} // namespace mlsovers
