#ifndef ERUMDPROBLEM_H
#define ERUMDPROBLEM_H


#include "./ppddl/PPDDLAction.h"
#include "./ppddl/PPDDLProblem.h"
#include "../include/UMDProblem.h"


namespace umd
{


/*
A class represening a Equi-Reward Utility Maximizing problem as decribed in "Equi-Reward Utility Maximizing Design in Stochastic Environments
Sarah Keren, Luis Pineda, Avigdor Gal, Erez Karpas, Shlomo Zilberstein" IJCAI-17
*/
class ErUmdProblem : public mlppddl::PPDDLProblem
{
    public:

        ErUmdProblem(problem_t* pProblem, problem_t* pProblem_tip_nodes, std::string solverName,std::string command_type);
        ErUmdProblem(problem_t* pProblem, problem_t* pProblem_tip_nodes, std::string str_fileName, std::string str_problemName, std::string str_domainName, std::string str_solverName,std::string command_type );
        virtual ~ErUmdProblem();
        virtual mlppddl::PPDDLProblem* getPPDDLProblem(){return ppddlProblem_;}
        // get the optimal policy for the umd problem using the solver (e.g. LAO*)
        virtual void solve(UmdHeuristic* umdHeur,bool timed);


        void fileName(std::string name) { fileName_ = name; }
        std::string getFileName(){return fileName_;}

        void problemName(std::string name) { problemName_ = name; }
        std::string getProblemName(){return problemName_;}

        void domainName(std::string name) { domainName_ = name; }
        std::string getDomainName(){return domainName_;}


        /**
        * Overrides method from pddlProblem.
        */
        virtual bool goal(mlcore::State* s) const;

        /**
        * Overrides method from pddlProblem.
        */
        virtual double cost(mlcore::State* s, mlcore::Action* a) const;


        int m_totalExpandedLAO = 0;
        int m_iteration_counterLAO =0;


        int m_totalVisitedFLARES = 0;




    protected:
       mlppddl::PPDDLProblem* ppddlProblem_;
       std::string domainName_;
       std::string solverName;
       std::string command_type;

    private:
        std::string fileName_;
        std::string problemName_;


};
}
#endif // ERUMDPROBLEM_H
