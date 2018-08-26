#include "../include/solvers/Solver.h"
#include "../include/LAOStarSolverS.h"

#include "../include/util/general.h"

#include <ctime>

namespace umd
{


mlcore::Action* LAOStarSolverS::solve(mlcore::State* s0)
{


    //std::cout<<"\n\nSTART: In LAOStarSolverS::solve(mlcore::State* s0)"<< s0<<std::endl;

    clock_t startTime = clock();
    double error = mdplib::dead_end_cost;
    int countExpanded;
    while (true) {
        do {

            //SARAH:START_DELETE
            /*
            mlcore::StateSet bpsg = mlcore::StateSet();
            std::cout<< "BOOBI" <<std::endl;
            mlsolvers::getBestPartialSolutionGraph(problem_, s0 ,bpsg);
            //std::cout << "After getting solution graph  " << std::endl;
            std::cout << "  Solution graph size: "<<bpsg.size()<< std::endl;
            mlcore::StateSet::const_iterator iterator;
            mlcore::Action* bestAction = NULL;

            for (iterator = bpsg.begin(); iterator != bpsg.end(); ++iterator) {
                    std::cout << "iterator:"<<*iterator<< " ";
                    //std::cout << endl<<"Before getting best action"<<endl;
                    bestAction = mlsolvers::greedyAction(problem_, *iterator);
                    //std::cout << endl<<"After getting best action"<<endl;
                    if (bestAction)
                    {std::cout << bestAction<<std::endl;
                    std::cout << (*iterator)->cost()<<std::endl;
                    }

                    else
                    {std::cout << "Goal State"<<std::endl;}


            }//for
            */

            //SARAH:END_DELETE




            visited.clear();
            countExpanded = expand(s0);

            this->m_totalExpanded += countExpanded;
            this->m_iteration_counter+=1;

            //std::cout<<" Expanded:"<< this->m_totalExpanded<<std::endl;
            //std::cout<<" iteration_counter:"<< this->m_iteration_counter<<std::endl;


            if ((0.001 * (clock() - startTime)) /
                    CLOCKS_PER_SEC > timeLimit_)
            {
                //std::cout<<" END LAO* for state: " <<s0 << "\n time out reached" <<std::endl;
                return s0->bestAction();
            }

        } while (countExpanded != 0);

        while (true) {
            if ((0.001 * (clock() - startTime)) /
                    CLOCKS_PER_SEC > timeLimit_)
            {
                //std::cout<<" END LAO* for state: " <<s0 << "\n time out reached" <<std::endl;
                return s0->bestAction();
            }

            visited.clear();
            error = testConvergence(s0);
            if (error < epsilon_)
                {
                    //std::cout<<" \n\nEND LAO* for state: " <<s0 << "\n converged" << std::endl;
                    return s0->bestAction();
                }
            if (error > mdplib::dead_end_cost) {
                break;  // BPSG changed, must expand tip nodes again
            }
        }
    }
}

int LAOStarSolverS::expand(mlcore::State* s)
{

    if (!visited.insert(s).second)  // state was already visited.
        return 0;
    if (s->deadEnd() || problem_->goal(s))
        return 0;
    //std::cout<<" in LAOSTAR: expand(" << s << ")"<< std::endl;
    int cnt = 0;
    if (s->bestAction() == nullptr) {
        // state has not been expanded.
        //std::cout<<" state: has not been expanded - bellman update"<< std::endl;
        mlsolvers::bellmanUpdate(problem_, s, weight_);
        return 1;
    } else {
        //std::cout<<" perform the best action which is "<< s->bestAction() << std::endl;
        mlcore::Action* a = s->bestAction();
        for (mlcore::Successor sccr : problem_->transition(s, a))
        {
            //std::cout<<" expanding successor"<< sccr.su_state<< std::endl;
            cnt += expand(sccr.su_state);
        }
    }
    //std::cout<<" perform a backup after expantion of " << s<<"\n";
    mlsolvers::bellmanUpdate(problem_, s, weight_);
    return cnt;
}

double LAOStarSolverS::testConvergence(mlcore::State* s)
{
    double error = 0.0;

    if (s->deadEnd() || problem_->goal(s))
        return 0.0;

    if (!visited.insert(s).second)
        return 0.0;

    mlcore::Action* prevAction = s->bestAction();
    if (prevAction == nullptr) {
        // if it reaches this point it hasn't converged yet.
        return mdplib::dead_end_cost + 1;
    } else {
        for (mlcore::Successor sccr : problem_->transition(s, prevAction))
            error =  std::max(error, testConvergence(sccr.su_state));
    }

    error = std::max(error, mlsolvers::bellmanUpdate(problem_, s, weight_));
    if (prevAction == s->bestAction())
        return error;
    // it hasn't converged because the best action changed.
    return mdplib::dead_end_cost + 1;
}

}

