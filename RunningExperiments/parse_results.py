__author__ = 'sarah'
__author__ = 'sarah'
import sys, os

SOLVERS= {'LAO*', 'FLARES'}
BFD_HEURISTIC_TYPES = {'rel-combined-proc','rel-proc','rel-combined','rel-mod','rel-env','compilation','bfs_design'}
MDP_HEURISTIC_TYPES = {'baod-heur','hmin-heur'}

BUDGET_ARRAY = {1,2,3,4,5}
NEW_BM_DELIMINATOR = 'File::'
NUMBER_OF_STEPS_TO_JUMP = 1

def parse_result_file(results_folder_name, output_file_name,domain, parse_nodes = True):

    # delete the old file
    output_file = open(output_file_name, 'w+')


    for filename in os.listdir(results_folder_name):
        results_file = open(os.path.join(results_folder_name,filename), 'r')
        #output_file  = open(output_file,'a')
        lines = results_file.readlines()
        line_index = 0
        while line_index < len(lines):
            time_out = False

            line = lines[line_index]

            if NEW_BM_DELIMINATOR in line :

                cost = -1
                time = -1
                problem_name  = 'error'
                budget = -1
                command_type = 'error'
                heuristic_name ='error'
                solver = 'error'
                simulated_expected_cost = -1
                stderr = -1

                Nodes_Examined = -1
                Design_Nodes_Examined = -1
                Nodes_Calculated = -1
                Design_Nodes_Calculated = -1



                # read 6 lines
                #print('new benchmark found')
                line_index = line_index + NUMBER_OF_STEPS_TO_JUMP
                bm_name =lines[line_index].split()[-1]
                if len(bm_name.split('-')) == 1:
                    problem_name = bm_name
                else:
                    problem_name =bm_name.split('-')[0]

                #print('problem_name: %s'%problem_name)
                #problem_name = lines[line_index].split()[0]
                #print('problem name is %s'%problem_name)
                if len(bm_name.split('-')) == 1:
                    budget = 0
                else:
                    budget =bm_name.split('-')[1]

                #print('budget: %s'%budget)
                line_index = line_index + 1
                solver = lines[line_index].split()[-1]
                line_index = line_index + 1
                command_type = lines[line_index].split()[-1]
                #print('command_type: %s'%command_type)
                line_index = line_index + 1
                heuristic_name = lines[line_index].split()[-1]
                #print('heuristic_name: %s'%heuristic_name)

                time_out = False
                eof = False
                #look for cost
                while 'cost' not in lines[line_index]:

                    # the problem timed out - break
                    if NEW_BM_DELIMINATOR in lines[line_index]:
                        time_out = True
                        break
                    line_index += 1


                    # end of file reached
                    if line_index >= len(lines):
                        eof = True
                        break

                if not (time_out or eof):
                    cost = lines[line_index].split()[-1].replace('cost::','')
                    cost = float(cost)


                    if 'FLARES' in solver:
                        while 'Simulated expected cost' not in lines[line_index]:

                            if line_index >= len(lines):
                                eof = True
                                break
                            if NEW_BM_DELIMINATOR in lines[line_index]:
                                time_out = True
                                break
                            line_index += 1


                        if not eof and not time_out:
                            sim_line = lines[line_index].split('::')
                            simulated_expected_cost = sim_line[1].replace('+/-','')
                            simulated_expected_cost = float(simulated_expected_cost)
                            stderr = sim_line[2].replace('\n','')
                            stderr = float(stderr)


                    if parse_nodes :

                        while 'Nodes Examined:' not in lines[line_index]:
                            if line_index >= len(lines):
                                eof = True
                                break
                            if NEW_BM_DELIMINATOR in lines[line_index]:
                                time_out = True
                                break
                            line_index += 1

                        if not eof and not time_out:
                            Nodes_Examined = int(lines[line_index].split()[-1])
                            line_index+=1
                            Design_Nodes_Examined =  int(lines[line_index].split()[-1])
                            line_index+=1
                            Nodes_Calculated = int(lines[line_index].split()[-1])
                            line_index+=1
                            Design_Nodes_Calculated = int(lines[line_index].split()[-1])

                    # get time
                    while 'Total time' not in lines[line_index]:

                        if line_index >= len(lines):
                            eof = True
                            break
                        if NEW_BM_DELIMINATOR in lines[line_index]:
                            time_out = True
                            break
                        line_index += 1

                    if not eof and not time_out:
                        time = lines[line_index].split()[-1]
                        time = time.replace('::','')
                        time = float(time)

                budget = int(budget)

                output_line = '%s, %d, %s, %s, %s, %.2f, %.2f, %d, %d, %d, %d, %.2f, %.2f'%(problem_name,budget,solver, command_type, heuristic_name,cost,time,Nodes_Examined,Design_Nodes_Examined, Nodes_Calculated, Design_Nodes_Calculated, simulated_expected_cost, stderr)
                print(output_line)
                output_line = output_line.replace(' ','')
                output_file.write(output_line)
                output_file.write('\n')
                output_file.flush()




            if not time_out:
                line_index = line_index+1


    output_file.close()
    return None


def anaylze_results_count_solved(results_file_name, domain):

    results_file = open(results_file_name,'r')
    results_lines = results_file.readlines()

    # counting the number of instances solved by each method (instances: budget, method: command+heuristic)
    count_solved_per_method_dictionary = {}
    for solver in SOLVERS:
        count_solved_per_method_dictionary[solver] = {}
        for budget in range(1,6):
            count_solved_per_method_dictionary[solver][budget] = {}
            for mdp_heur in MDP_HEURISTIC_TYPES:
                count_solved_per_method_dictionary[solver][budget][mdp_heur] = {}
                for method in BFD_HEURISTIC_TYPES:
                    entry_key = '%s'%(method)
                    count_solved_per_method_dictionary[solver][budget][mdp_heur][entry_key] = 0


    for line in results_lines:
        [problem_name,budget,solver, command_type, heuristic_name,cost,time,Nodes_Examined,Design_Nodes_Examined, Nodes_Calculated, Design_Nodes_Calculated, simulated_expected_cost, stderr] = line.split(',')
        entry_key = '%s'%(command_type)
        if float(cost) >= 0:
            (count_solved_per_method_dictionary[solver][int(budget)][heuristic_name])[entry_key] += 1



    return count_solved_per_method_dictionary



def anaylze_results_running_time_and_nodes(results_file_name, domain):

    results_file = open(results_file_name,'r')
    results_lines = results_file.readlines()

    # keeping the results achieved for each instance
    instance_dictionary = {1:{},2:{},3:{},4:{},5:{}}


    for line in results_lines:

        [problem_name,budget,solver, command_type, heuristic_name,cost,time,nodes_Examined,design_Nodes_Examined, Nodes_Calculated, Design_Nodes_Calculated, simulated_expected_cost, stderr] = line.split(',')
        budget = int(budget)
        entry_key = '%s:%s:%s'%(domain,problem_name,budget)
        # enter the instance enrty if it is not there
        if not instance_dictionary[budget].get(entry_key):
            instance_dictionary[budget][entry_key] = {}
            for solver_ in SOLVERS:
                instance_dictionary[budget][entry_key][solver_] = {}
                for heur_ in MDP_HEURISTIC_TYPES:
                    (instance_dictionary[budget][entry_key][solver_])[heur_] = {}


        method_entry_key = '%s'%(command_type)

        ((instance_dictionary[budget][entry_key])[solver][heuristic_name])[method_entry_key] = [float(time),nodes_Examined,design_Nodes_Examined]


    return instance_dictionary






if __name__ == '__main__' :


    parsed_results_files = []
    for domain in ['blocksworld', 'ex-blocksworld', 'triangle-tireworld', 'vacuum-no-fuel','elevators', 'boxworld']:# ['ex-blocksworld','boxworld','blocksworld', 'elevators', 'triangle_tire', 'vacuum']:

        print('\n\n\ndomain: %s \n\n\n'%domain)


        #results_folder_name= '/home/sarah/Dropbox/er-umd-2018/FinalResults/Optimal/exp_results_%s'%(domain)
        #is_optimal = True

        results_folder_name = '/home/sarah/Documents/GoalRecognitionDesign/Redesign/ER-UMD-2019/ER-UMD/results/%s'%domain

        output_file_name  = '/home/sarah/Documents/GoalRecognitionDesign/Redesign/ER-UMD-2019/ER-UMD/parsed_results/parsed_results_%s.txt'%(domain)

        parse_nodes = False
        if 'blocksworld' in domain:
            parse_nodes = True


        parse_result_file(results_folder_name, output_file_name, domain, parse_nodes)

        anaylze_results_count_solved(output_file_name, domain)
        anaylze_results_running_time_and_nodes(output_file_name, domain)




