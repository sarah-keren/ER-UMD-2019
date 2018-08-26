#include "../include/ppddl/PPDDLAction.h"
#include "../include/PPDDLProblemS.h"
#include "../include/ppddl/PPDDLState.h"

namespace umd
{

PPDDLProblem::PPDDLProblem(problem_t* pProblem) : pProblem_(pProblem)
{

    pProblem_->instantiate_actions();
    pProblem_->flatten();
    state_t::initialize(*pProblem_);

    // Getting initial state for the problem
    for (int i = 0; i < DISP_SIZE; i++)
        display_[i].first = new state_t;

    pProblem_->initial_states(display_);
    s0 = new mlppddl::PPDDLState(this);
    ((mlppddl::PPDDLState *) s0)->setPState(*display_[0].first);
    this->addState(s0);

    actionList_t pActions = pProblem_->actionsT();
    for (int i = 0; i < pActions.size(); i++)
        actions_.push_back(new mlppddl::PPDDLAction(pActions[i], i));
}


bool PPDDLProblem::goal(mlcore::State* s) const
{
    mlppddl::PPDDLState* state = (mlppddl::PPDDLState *) s;
    return pProblem_->goal().holds(*state->pState());
}


std::list<mlcore::Successor>
    PPDDLProblem::transition(mlcore::State* s, mlcore::Action* a)
{
    std::list<mlcore::Successor> successors;

    mlppddl::PPDDLAction* action = (mlppddl::PPDDLAction *) a;
    mlppddl::PPDDLState* state = (mlppddl::PPDDLState *) s;

    pProblem_->expand(*action->pAction(), *state->pState(), display_);
    for (int i = 0; display_[i].second != Rational(-1); i++) {
        std::cout<<"Successor " << i <<std::endl;
        mlppddl::PPDDLState* nextState = new mlppddl::PPDDLState(this);
        nextState->setPState(*display_[i].first);
        successors.push_back(
            mlcore::Successor(this->addState(nextState),
                              display_[i].second.double_value()));
    }
    return successors;
}



double PPDDLProblem::cost(mlcore::State* s, mlcore::Action* a) const
{


    std::cout<< "cost for state: "<< s << "and action "<< a <<std::endl;
    mlppddl::PPDDLAction* action = (mlppddl::PPDDLAction *) a;
    mlppddl::PPDDLState* state = (mlppddl::PPDDLState *) s;

    std::string name = action->pAction()->name();
    if ((name.find("design") != std::string::npos) && (name.find("idle") != std::string::npos)) {
        return 1.0e-4/2;
    }

    if (name.find("design") != std::string::npos) {
        return 1.0e-4;
    }

    double cost = action->pAction()->cost(*state->pState());
    //std::cout<< "cost for state: "<< state << "and action "<< action << " is: "<< cost<<std::endl;
    return cost;
}


bool PPDDLProblem::applicable(mlcore::State* s, mlcore::Action* a) const
{
    mlppddl::PPDDLAction* action = (mlppddl::PPDDLAction *) a;
    mlppddl::PPDDLState* state = (mlppddl::PPDDLState *) s;

    return action->pAction()->enabled(*state->pState());
}

}
