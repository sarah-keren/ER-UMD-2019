(define (domain vacuum-no-fuel-design-relaxed)
  (:requirements :typing :strips :equality :probabilistic-effects :rewards)

  (:types location dirt time)

  (:predicates (robot-at ?x_loc ?y_loc - location)
	       (dirt-at ?dirt - dirt ?x_loc - location ?y_loc - location)
	       (dirt-in-robot ?dirt - dirt)
	       (occupied ?x ?y - location)
	       (execution)	
               (current-time ?t1 - time)
	       (next ?t1 - time ?t2 - time)	
	       (prox ?coordinate - location ?coordinate_next - location)	
	       (enabled-remove-occupancy ?x - location ?y - location)
	       (remove-occupancy-x ?x - location)
  )

;; enabled actions 

  (:action move-robot-x-enabled-a
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (prox ?x_from ?x_to) (enabled-remove-occupancy ?x_to ?y) (occupied ?x_to ?y))
    :effect (and (robot-at ?x_to ?y))
    
   )

  (:action move-robot-x-enabled-b
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (prox ?x_from ?x_to) (enabled-remove-occupancy ?x_to ?y) (occupied ?x_to ?y))
    :effect (and (robot-at ?x_from ?y))
	    
   )


 (:action move-robot-y-enabled-a
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (prox ?y_from ?y_to) (enabled-remove-occupancy ?x ?y_to) (occupied ?x ?y_to))
    :effect (and (robot-at ?x ?y_to))			
	    
   )


 (:action move-robot-y-enabled-b
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (prox ?y_from ?y_to) (enabled-remove-occupancy ?x ?y_to) (occupied ?x ?y_to))
    :effect (and (robot-at ?x ?y_from))		          
	    
   )


  (:action move-robot-x-a
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to))
    :effect (and (robot-at ?x_to ?y))
	    
   )

  (:action move-robot-x-b
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to))
    :effect (and (robot-at ?x_from ?y))                 
	    
   )



 (:action move-robot-y-a
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to))
    :effect (and (robot-at ?x ?y_to))
   )


 (:action move-robot-y-b
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to))
    :effect (and (robot-at ?x ?y_from))  
   )



 (:action loaddirt
    :parameters (?x_loc - location ?y_loc - location ?dirt -dirt)
    :precondition (and (execution) (robot-at ?x_loc ?y_loc) (dirt-at ?dirt ?x_loc ?y_loc))
    :effect (and (dirt-in-robot ?dirt) (not (dirt-at ?dirt ?x_loc ?y_loc))))


 (:action unloaddirt
    :parameters (?x_loc - location ?y_loc - location ?dirt -dirt)
    :precondition (and (execution) (robot-at ?x_loc ?y_loc) (dirt-in-robot ?dirt))
    :effect (and (not (dirt-in-robot ?dirt)) (dirt-at ?dirt ?x_loc ?y_loc)))


 

;Design actions


  (:action design-start-execution
    :parameters ()
    :precondition (and (not (execution)))
    :effect (and (execution))
  )



;remove furniture
  (:action design-remove-occupancy
    :parameters (?x - location ?y - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (occupied ?x ?y))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-remove-occupancy ?x ?y) (remove-occupancy-x ?x))
  )


)

