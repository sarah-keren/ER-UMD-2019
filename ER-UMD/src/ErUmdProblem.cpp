#include <stdio.h>

#include "../include/UMDProblem.h"
#include "../include/UmdDefs.h"
#include "../include/UmdUtils.h"
#include "./solvers/Solver.h"
#include "./solvers/FLARESSolver.h"
#include "./solvers/FLARESSolver.h"
#include "../include/DeterministicSolver.h"
#include "../include/LAOStarSolverS.h"

#include "./solvers/LRTDPSolver.h""
#include "../include/ErUmdProblem.h"

#include <sstream>
/*
#include "./reduced/PPDDLTaggedReduction.h"
#include "./reduced/ReducedHeuristicWrapper.h"
#include "./reduced/ReducedModel.h"
#include "./reduced/ReducedState.h"
#include "./reduced/ReducedTransition.h"

#include "./solvers/FFReducedModelSolver.h"
*/
namespace umd
{

ErUmdProblem::ErUmdProblem(problem_t* pProblem, problem_t* pProblem_tip_nodes, std::string str_solverName,std::string command):mlppddl::PPDDLProblem (pProblem)
{
                                                                               // std::cout << "CONSTR1 " << pProblem_tip_nodes->domain().name() << std::endl;
//                                                                                std::cout << pProblem_tip_nodes->domain() << std::endl;
    ppddlProblem_ = new mlppddl::PPDDLProblem(pProblem_tip_nodes);
//                                                                                auto currentState = ppddlProblem_->initialState();
//                                                                                std::list< std::pair<mlcore::State*, int> > my_queue;
//                                                                                my_queue.push_back(std::make_pair(currentState, 0));
//                                                                                while (true) {
//                                                                                    auto sd = my_queue.front();
//                                                                                    my_queue.pop_front();
//                                                                                    if (sd.second == 4)
//                                                                                        continue;
//                                                                                    currentState = sd.first;
//                                                                                    std::cout << "depth " << sd.second << " " << currentState << std::endl;
//                                                                                    int depth = sd.second;
//                                                                                    for (auto action : ppddlProblem_->actions()) {
//                                                                                        if (!ppddlProblem_->applicable(currentState, action))
//                                                                                            continue;
//                                                                                        std::cout << "  " << action << std::endl;
//                                                                                        for (auto successor : ppddlProblem_->transition(currentState, action)) {
//                                                                                            std::cout << "    " << successor.first << " " << successor.second << std::endl;
//                                                                                            my_queue.push_back(std::make_pair(successor.first, depth + 1));
//                                                                                        }
//
//                                                                                    }
//                                                                                }
//                                                                                exit(0);
    domainName_ = pProblem->domain().name();
    solverName = str_solverName;
    command_type = command;

}

ErUmdProblem::ErUmdProblem(problem_t* pProblem, problem_t* pProblem_tip_nodes, std::string str_fileName, std::string str_problemName, std::string str_domainName, std::string str_solverName,std::string command):mlppddl::PPDDLProblem (pProblem)
{
//                                                                                std::cout << "CONSTR2 " << pProblem_tip_nodes->domain().name() << std::endl;
    ppddlProblem_ = new mlppddl::PPDDLProblem (pProblem_tip_nodes);
    fileName(str_fileName);
    problemName(str_problemName);
    domainName(str_domainName);
    solverName = str_solverName;
    command_type = command;
}

ErUmdProblem::~ErUmdProblem()
{
 if (ppddlProblem_)
 {    delete ppddlProblem_;
      ppddlProblem_ = NULL;
 }

}

void ErUmdProblem::solve(UmdHeuristic* umdHeur, bool timed)
{

    // solve the compilation\original problem with a single search
    if((command_type.find(umddefs::compilation) != std::string::npos)|| (command_type.find(umddefs::original) != std::string::npos))
    {

        int iExpandedNodesExecution = -1;
        int iExpandedNodesDesign = -1;
        if (solverName.find(umddefs::solverLAO) != std::string::npos) {

            //SOLVE
            this->ppddlProblem_->setHeuristic(umdHeur->get_executionHeuristic_());
            LAOStarSolverS solver(this->ppddlProblem_);

            solver.solve(this->ppddlProblem_->initialState());

            //ANALYZE AND LOG
            double cost = this->ppddlProblem_->initialState()->cost();
            std::cout << "Initial state:: "<<this->ppddlProblem_->initialState()<<std::endl;
            std::cout<< "Expected cost:: "<< this->ppddlProblem_->initialState()->cost()<<std::endl;
            //umdutils::print_policy_pddl(this->ppddlProblem_);
            std::cout << "Best action:: "<< this->ppddlProblem_->initialState()->bestAction() << std::endl;

            int nodes_examined = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter();
            int nodes_calculated = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated() ;
            int design_nodes_examined = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter() ;
            int design_nodes_calculated = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter_calculated() ;
            std::cout << "Nodes Examined: "<< nodes_examined << "\nDesign Nodes Examined: " << design_nodes_examined <<"\nNodes Calculated: "<< nodes_calculated <<"\nDesign Nodes Calculated: " << design_nodes_calculated << std::endl;

            /*
            iExpandedNodesExecution = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter();
            iExpandedNodesDesign = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter();
            std::cout << "Expanded nodes::" << iExpandedNodesExecution << " \nExpanded Design nodes::" <<iExpandedNodesDesign<< std::endl;
            std::cout<<"Calculate nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated()<< std::endl;
            std::cout<<"Calculate design nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter_calculated()<< std::endl;
            //std::cout <<"Algorithm Total Expanded nodes::" << solver.m_totalExpanded << " Iteration coutner::"<< solver.m_iteration_counter<<std::endl;
            */

            return;
        } else {

            if (solverName.find(umddefs::solverFLARES)!= std::string::npos) {
//                                                                                std::cout << "DOMAIN " << this->ppddlProblem_->pProblem()->domain().name() << std::endl;
//                                                                                std::cout << this->ppddlProblem_->pProblem()->domain() << std::endl;
                // This is the suboptimal solver part

                // SOLVE
                this->ppddlProblem_->setHeuristic(umdHeur->get_executionHeuristic_());
                mlsolvers::FLARESSolver solver(this->ppddlProblem_, umddefs::flares_sims, 1.0e-3, 0);
                solver.solve(this->ppddlProblem_->initialState());

                // ANALYZE
                std::cout << "Initial state::"<<this->ppddlProblem_->initialState();
                std::cout << "Expanded nodes::" << m_totalVisitedFLARES <<std::endl;


                //SIMULATE
                umdutils::simulation_result simulated_result = umdutils::simulateCost(umddefs::flares_sims,this,&solver, this->ppddlProblem_->initialState());
                std::cout << "Estimated cost::" << this->ppddlProblem_->initialState()->cost() << std::endl;
                std::cout << "ExpectedCost::" << simulated_result.averageCost << " +/- ::" << simulated_result.stderr << std::endl;
                std::cout << "Best action::" << this->ppddlProblem_->initialState()->bestAction() << std::endl;

                int nodes_examined = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter();
                int nodes_calculated = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated() ;
                int design_nodes_examined = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter() ;
                int design_nodes_calculated = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter_calculated() ;
                std::cout << "Nodes Examined: "<< nodes_examined << "\nDesign Nodes Examined: " << design_nodes_examined <<"\nNodes Calculated: "<< nodes_calculated <<"\nDesign Nodes Calculated: " << design_nodes_calculated << std::endl;


                /*
                iExpandedNodesExecution = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter();
                iExpandedNodesDesign = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter();
                std::cout << "Expanded nodes::" << iExpandedNodesExecution << " Expanded Design nodes::" <<iExpandedNodesDesign<< std::endl;// <<"  Total Expanded nodes algorithm:: " << solver.m_totalExpanded << " Iteration coutner:: "<< solver.m_iteration_counter<<std::endl;
                std::cout<<"Simulation results:: "<< "num_of_runs::"<< simulated_result.num_of_runs<< " num_of_solved::" <<simulated_result.num_of_solved<< " averageCost: "<< simulated_result.averageCost <<" stderr: "<< simulated_result.stderr << " averageCost_solved::"<< simulated_result.averageCost_solved << " stderr_solved::" <<simulated_result.stderr_solved<< std::endl;
                std::cout<<"Calculate nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated()<< std::endl;
                std::cout<<"Calculate design nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter_calculated()<< std::endl;
                */


                }//if sub optimal
                else //error
                {
                    std::cout<< "Error-solver "<< solverName <<" not suported " << std::endl;
                    throw Exception( "Error-solver not suported ");

                }
        }//else
    }

    // BFD
    else
    {
        this->ppddlProblem_->setHeuristic(umdHeur->get_executionHeuristic_());


        //mlsolvers::LAOStarSolverS solver(this->ppddlProblem_);

        if (solverName.find(umddefs::solverFLARES)!= std::string::npos)
        {
            //deterministic solver
            if (command_type.find(umddefs::solverLAO)== std::string::npos)
            {

                //SOLVE
                DeterministicSolver solver (this, det_most_likely, umdHeur);
                //solve the problem
                mlcore::Action* best_action = solver.solve(this->initialState());
                //std::pair <double,double> simulated_result = umdutils::simulateCost(umddefs::flares_sims,this,&solver, ppddlProblem_->initialState());

                //get the first execution state and simulate on it
                mlcore::State* best_design_state = solver.bestDesignState;
                mlcore::Action* cur_best_action = best_action;
                /*while (umdutils::isDesign(cur_state))
                {
                    std::cout<< " cur_state: " << cur_state<< " is a design node " <<std::endl;
                    //cur_state = mlsolvers::randomSuccessor(this->ppddlProblem_, cur_state, cur_best_action);
                    //design actions are deterministic
                    //cur_state = (this->ppddlProblem_, cur_state, cur_best_action, false);

                    //cur_best_action = mlsolvers::greedyAction(this->ppddlProblem_, cur_state);
                }
                */

                //silent the logging of the simualted values
                solver.set_log_results(false);
                //create flares solver for this node
                std::string original_command_type = this->command_type;
                this->command_type = umddefs::compilation;
                mlsolvers::FLARESSolver sim_solver(this->ppddlProblem_, umddefs::flares_sims, 1.0e-3, 0);
                solver.solve(this->ppddlProblem_->initialState());

                umdutils::simulation_result simulated_result = umdutils::simulateCost(umddefs::flares_sims,this,&sim_solver, best_design_state);
                this->command_type = original_command_type;
                solver.set_log_results(true);

                std::cout<<"Simulated expected cost::"<< simulated_result.averageCost<< " +/- ::"<< simulated_result.stderr<<std::endl;
                std::cout<<"Simulation results::"<< " num_of_runs::"<< simulated_result.num_of_runs<< " num_of_solved::" <<simulated_result.num_of_solved<< " averageCost: "<< simulated_result.averageCost <<" stderr: "<< simulated_result.stderr << " averageCost_solved::"<< simulated_result.averageCost_solved << " stderr_solved::" <<simulated_result.stderr_solved<< std::endl;

                /*
                std::cout<<"Calculate nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated()<< std::endl;
                std::cout<<"Calculate design nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter_calculated()<< std::endl;
                */
            }
            else //laostar
            {

                //SOLVE
                LAOStarSolverS solver (this);
                //solve the problem
                mlcore::Action* best_action = solver.solve(this->initialState());
                //std::pair <double,double> simulated_result = umdutils::simulateCost(umddefs::flares_sims,this,&solver, ppddlProblem_->initialState());

                std::cout<<" COOMPLETE !!!!!!!!!!!!!!!!!!!!!!!!\n" <<std::endl;

            }


        }
        else //not flares
        {
            //deterministic solver
            if (command_type.find(umddefs::solverLAO)== std::string::npos)
            {
                //SOLVE
                DeterministicSolver solver (this, det_most_likely, umdHeur);
                mlcore::Action* best_action = solver.solve(this->initialState());            //ANALYZE
                std::cout << "Initial state::" << this->initialState() <<std::endl;
                //std::cout << "Expected cost:: "<< this->initialState()->cost()<<std::endl;
                //std::cout << "Best action:: " << best_action <<std::endl;
            }
            else //
            {
              //SOLVE
             this->setHeuristic(umdHeur);
              LAOStarSolverS solver (this);
              mlcore::Action* best_action = solver.solve(this->initialState());            //ANALYZE
              std::cout << "Initial state::" << this->initialState() <<std::endl;


            }

        }


        int nodes_examined = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter()+((MDPHeuristic*)umdHeur->get_designHeuristic_())->get_counter();
        int nodes_calculated = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated() +((MDPHeuristic*)umdHeur->get_designHeuristic_())->get_counter_calculated() ;
        int design_nodes_examined = ((MDPHeuristic*)umdHeur->get_designHeuristic_())->get_design_state_counter() ;
        int design_nodes_calculated = ((MDPHeuristic*)umdHeur->get_designHeuristic_())->get_design_state_counter_calculated() ;
        std::cout << "Nodes Examined: "<< nodes_examined << "\nDesign Nodes Examined: " << design_nodes_examined <<"\nNodes Calculated: "<< nodes_calculated <<"\nDesign Nodes Calculated: " << design_nodes_calculated << std::endl;


        /*
       int iExpandedNodesExecution = ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter();
       int iExpandedNodesDesign = ((MDPHeuristic*)umdHeur->get_designHeuristic_())->get_counter();

        std::cout << "Expanded nodes:: Execution::" << iExpandedNodesExecution << " Design::" << iExpandedNodesDesign<< " Total::" << iExpandedNodesDesign+iExpandedNodesExecution<<std::endl;
        std::cout<<"Calculate nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_counter_calculated()<< std::endl;
        std::cout<<"Calculate design nodes::" << ((MDPHeuristic*)umdHeur->get_executionHeuristic_())->get_design_state_counter_calculated()<< std::endl;
        std::cout << "UMD heuristic:: Examined nodes::" << umdHeur->get_examinedStateCounter() << " Expanded nodes::" << umdHeur->get_expandedStateCounter() <<std::endl;
        // if the solver used for the nodes is flares - simulate on the value
        */

        return;
    }


    //std::cout<<mlsolvers::FLARESSolver::COUNTER_VISITED;

}

//goal states are execution nodes
 bool ErUmdProblem::goal(mlcore::State* s) const
 {

    if((command_type.find(umddefs::compilation) != std::string::npos)|| (command_type.find(umddefs::original) != std::string::npos))
    {
            bool isGoal = this->ppddlProblem_->goal(s);
            return isGoal;

    }

    else
    {

        // the goal is achieved when the extracted noded is an execution node
        std::stringstream buffer;
        buffer<<(mlppddl::PPDDLState*)s;

        if (buffer.str().find(umddefs::execution_stage_string) != std::string::npos)
        {
            //std::cout << "at goal : execution node" << std::endl;
            return true;

        }
        //std::cout << "not yet at goal" << std::endl;

        return false;
    }
 }

double ErUmdProblem::cost(mlcore::State* s, mlcore::Action* a) const
{

    std::string actionName = ((mlppddl::PPDDLAction*)a)->pAction()->name();
    //std::cout << "\n\n\n in ErUmdProblem::cost with state" << s << " and action "<< a<<  " and command: "<< command_type<< " \n\n\n\n"<<  std::endl;

    //for the compilation and redular solution - the cost is the cost of the action
      if((command_type.find(umddefs::compilation) != std::string::npos)|| (command_type.find(umddefs::original) != std::string::npos))
      {

        if (actionName.find(umddefs::design_stage_string) != std::string::npos)
        {
            if(actionName.find(umddefs::idle_string) != std::string::npos)
            {
                // if the action is a idle design action - the cost is epsilon/2
                //std::cout << " cost is " << 1.0e-4/2 << std::endl;
                return 1.0e-4/2;
            }
            else
            {
                // if the action is a design action - the cost is epsilon
                //std::cout << " cost is " << 1.0e-4 << std::endl;
                return 1.0e-4;
            }
        }
        else  //not a design action
        {
            double qAction = this->ppddlProblem_->cost(s, a);
            //std::cout<<" qation is: "<< qAction<<std::endl;
            return qAction;
         }

      }



    // for design actions that do not start execution
    if (actionName.find(umddefs::design_start_execution) == std::string::npos)
    {
        if (actionName.find(umddefs::design_stage_string) != std::string::npos)
        {
            if(actionName.find(umddefs::idle_string) != std::string::npos)
            {
                // if the action is a idle design action - the cost is epsilon/2
                //std::cout << " cost is " << 1.0e-4/2 << std::endl;
                return 1.0e-4/2;
            }
            else
            {
                // if the action is a design action - the cost is epsilon
                //std::cout << " cost is " << 1.0e-4 << std::endl;
                return 1.0e-4;
            }

        }
        else
        {
            std::cout<< "Error in ErUmdProblem::cost with action " <<actionName <<std::endl;
            throw Exception( "Error in ErUmdProblem::cost with action " + actionName );


        }


    }


    else
    {

    // the action is a start execution action the cost is the cost of the underlying mdp
    if (solverName.find(umddefs::solverLAO)!= std::string::npos) {
            // TODO: change this if(true) to have an appropriate option
            LAOStarSolverS solver(this->ppddlProblem_);
            auto successors = ppddlProblem_->transition(s,a);
            mlcore::State* s0 = successors.front().su_state;
            solver.solve(s0);
            double cost = s0->cost();
            //std::cout << "\n for state: "<<s << " and successor state: " << s0 <<" cost is:  "<< cost<<std::endl;
            return cost;
        } else {

            if (solverName.find(umddefs::solverFLARES)!= std::string::npos) {
                mlsolvers::FLARESSolver solver(this->ppddlProblem_, umddefs::flares_sims, 1.0e-3, 0);
                unsigned long startTime = clock();
                solver.solve(s);
                unsigned long endTime = clock();
                double planTime = (double(endTime - startTime) / CLOCKS_PER_SEC);

                if (umddefs::simulate_at_tips_flares)
                {
                    //std::pair <double,double> simulated_result = umdutils::simulateCost(umddefs::flares_sims,this->ppddlProblem_,&solver, s);
                    umdutils::simulation_result simulated_result = umdutils::simulateCost(umddefs::flares_sims,this->ppddlProblem_,&solver, s);
                    //std::cout<<"Simulated cost is "<< simulated_result.first<< "\n mean is "<< simulated_result.second<< " s->cost() is "<< s->cost()<<std::endl;
                    return simulated_result.averageCost;
                }
                else
                {
                    return s->cost();
                }


            }
            else
            {

                std::cout<< "Error in ErUmdProblem::cost - solver " <<solverName << "not supported" <<std::endl;
                throw Exception( "Error in ErUmdProblsem::cost - solver not supported");




            }

          }
        }


}

}
/*
                double expectedCost = 0.0;
                double expectedTime = 0.0;
                std::vector<double> simCosts;
                int numSims = umddefs::flares_sims;
                for (int sim = 0; sim < numSims; sim++) {
                    double cost = 0.0;
                    double planningTime = 0.0;
                    mlcore::State* currentState = this->ppddlProblem_->initialState();
                    unsigned long startTime = clock();
                    //if already lableled - it will return
                    solver.solve(currentState);
                    unsigned long endTime = clock();
                    planningTime += (double(endTime - startTime) / CLOCKS_PER_SEC);
                    mlcore::Action* action = currentState->bestAction();
                    while (cost < mdplib::dead_end_cost) {
//                                                                                std::cerr << (void *) action << std::endl;
                        cost += this->ppddlProblem_->cost(currentState, action);
//                                                                                std::cout << this->ppddlProblem_->cost(currentState, action) << " " << cost << std::endl;
                        // The successor state according to the
                        // original transition model.
//                                                                                for (auto successor : ppddlProblem_->transition(currentState, action)) {
//                                                                                    std::cout << "             " << successor.first << " " << successor.second << std::endl;
//                                                                                }
                        mlcore::State* nextState =
                            mlsolvers::randomSuccessor(
                                this->ppddlProblem_, currentState, action);
//                                                                                std::cout << action << " " << nextState << std::endl;
                        if (this->ppddlProblem_->goal(nextState)) {
                            break;
                        }
                        currentState = nextState;
                        // Re-planning if needed.
                        if (!currentState->checkBits(mdplib::SOLVED_FLARES)) {
//                                                                                std::cerr << "replan"<< std::endl;
                            startTime = clock();
                            solver.solve(currentState);
                            endTime = clock();
                            planningTime +=
                                (double(endTime - startTime) / CLOCKS_PER_SEC);
                        }
                        if (currentState->deadEnd()) {
//                                                                                std::cout << "DEAD-END" << std::endl;
                            cost = mdplib::dead_end_cost;
                        }

                        action = currentState->bestAction();
                    }
                    expectedCost += cost;
                    simCosts.push_back(cost);
                    expectedTime += planningTime;
//                                                                                std::cout << "*******************************" << std::endl;
                }

                double averageCost = expectedCost/numSims;
                double stderr = 0.0;
                for (double cost : simCosts) {
                    double diff = (cost - averageCost);
                    stderr += diff * diff;
                }
                stderr /= (numSims - 1);
                stderr = sqrt(stderr / numSims);
                */

