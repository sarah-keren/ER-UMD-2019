(define (domain vacuum-no-fuel-design)
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
	       (enabled-move-safely-x ?x - location ?y - location ?x_to - location)
	       (enabled-move-safely-y ?x - location ?y - location ?y_to - location)
	       (safety-x ?x - location)
  )

;; enabled actions 

  (:action move-robot-x-enabled
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (prox ?x_from ?x_to) (enabled-remove-occupancy ?x_to ?y) (occupied ?x_to ?y))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))
				0.2 (robot-at ?x_from ?y)))
	    
   )

 (:action move-robot-y-enabled
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (prox ?y_from ?y_to) (enabled-remove-occupancy ?x ?y_to) (occupied ?x ?y_to))
    :effect (and(probabilistic 0.8 (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))
  		               0.2 (robot-at ?x ?y_from)))	    
   )


  (:action move-robot-x
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))
		                0.2 (robot-at ?x_from ?y)))
  		 
   )



  (:action move-robot-x-safe
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to)(enabled-move-safely-x ?x_from ?y ?x_to))
    :effect (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))  		 
   )


 (:action move-robot-y
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))
		                0.2 (robot-at ?x ?y_from)))
   )

  (:action move-robot-x-safe
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to)(enabled-move-safely-y ?x ?y_from ?y_to))
    :effect (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))  		 
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

  ;reduce friction

  (:action design-reduce-friction-x
    :parameters (?x - location ?y - location ?x_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?x ?x_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-x ?x ?y ?x_to)(safety-x ?x_to))
  )


  (:action design-reduce-friction-y
    :parameters (?x - location ?y - location ?y_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?y ?y_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-y ?x ?y ?y_to)(safety-x ?x))
  )

	       

)

(define (domain vacuum-no-fuel)
  (:requirements :typing :strips :equality :probabilistic-effects :rewards)

  (:types location dirt time)

  (:predicates (robot-at ?x_loc ?y_loc - location)
	       (dirt-at ?dirt - dirt ?x_loc - location ?y_loc - location)
	       (dirt-in-robot ?dirt - dirt)
	       (occupied ?x ?y - location)
	       (current-time ?t1 - time)
	       (next ?t1 - time ?t2 - time)	
	       (enabled-safety-move ?x_from ?y_from ?x_to ?y_to - location)
	       (prox ?coordinate - location ?coordinate_next - location)	
         
  )



  (:action move-robot-x
    :parameters(?x_from - location ?x_to - location ?y - location )
    :precondition (and(robot-at ?x_from ?y)(not(occupied ?x_to ?y))(prox ?x_from ?x_to))
    :effect (and (probabilistic 0.8 (and(not(robot-at ?x_from ?y))(robot-at ?x_to ?y))
				0.2 (robot-at ?x_from ?y)
;				0.2 (forall (?x_loc - location)(when (and(prox ?x_from ?x_loc)(not(occupied ?x_loc ?y)))(robot-at ?x_loc ?y)))
		)
           )
	    
   )

 

 (:action move-robot-y
    :parameters(?x - location ?y_from - location ?y_to - location)
    :precondition (and(robot-at ?x ?y_from)(not(occupied ?x ?y_to))(prox ?y_from ?y_to))
    :effect (and (probabilistic 0.8 (and(not(robot-at ?x ?y_from))(robot-at ?x ?y_to))
				0.2 (robot-at ?x ?y_from)
;				0.2 (forall (?y_loc - location)(when (and(prox ?y_from ?y_loc)(not(occupied ?x ?y_loc)))(robot-at ?x ?y_loc)))
		)
           )
	    
   )



 (:action loaddirt
    :parameters(?x_loc - location ?y_loc - location ?dirt -dirt)
    :precondition (and(robot-at ?x_loc ?y_loc) (dirt-at ?dirt ?x_loc ?y_loc))
    :effect (and(dirt-in-robot ?dirt) (not(dirt-at ?dirt ?x_loc ?y_loc))))


 (:action unloaddirt
    :parameters(?x_loc - location ?y_loc - location ?dirt -dirt)
    :precondition (and(robot-at ?x_loc ?y_loc) (dirt-in-robot ?dirt))
    :effect (and(not(dirt-in-robot ?dirt)) (dirt-at ?dirt ?x_loc ?y_loc)))


  

)


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
	       (enabled-move-safely-x ?x - location ?y - location ?x_to - location)
	       (enabled-move-safely-y ?x - location ?y - location ?y_to - location)
	       (safety-x ?x - location)
  )

;; enabled actions 

  (:action move-robot-x-enabled
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (prox ?x_from ?x_to) (enabled-remove-occupancy ?x_to ?y) (occupied ?x_to ?y))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))
				0.2 (robot-at ?x_from ?y)))
	    
   )

 (:action move-robot-y-enabled
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (prox ?y_from ?y_to) (enabled-remove-occupancy ?x ?y_to) (occupied ?x ?y_to))
    :effect (and(probabilistic 0.8 (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))
  		               0.2 (robot-at ?x ?y_from)))	    
   )


  (:action move-robot-x
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))
		                0.2 (robot-at ?x_from ?y)))
  		 
   )



  (:action move-robot-x-safe
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to)(enabled-move-safely-x ?x_from ?y ?x_to))
    :effect (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))  		 
   )


 (:action move-robot-y
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))
		                0.2 (robot-at ?x ?y_from)))
   )

  (:action move-robot-x-safe
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to)(enabled-move-safely-y ?x ?y_from ?y_to))
    :effect (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))  		 
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

  ;reduce friction

  (:action design-reduce-friction-x
    :parameters (?x - location ?y - location ?x_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?x ?x_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-x ?x ?y ?x_to)(safety-x ?x_to))
  )


  (:action design-reduce-friction-y
    :parameters (?x - location ?y - location ?y_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?y ?y_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-y ?x ?y ?y_to)(safety-x ?x))
  )

	       

)

(define (domain vacuum-no-fuel-design-over)
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
	       (enabled-move-safely-x ?x - location ?y - location ?x_to - location)
	       (enabled-move-safely-y ?x - location ?y - location ?y_to - location)
	       (safety-x ?x - location)
  )

;; enabled actions 

  (:action move-robot-x-enabled
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (prox ?x_from ?x_to) (remove-occupancy-x ?x_from) (occupied ?x_to ?y))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))
				0.2 (robot-at ?x_from ?y)))
	    
   )

 (:action move-robot-y-enabled
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (prox ?y_from ?y_to) (remove-occupancy-x ?x) (occupied ?x ?y_to))
    :effect (and(probabilistic 0.8 (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))
  		               0.2 (robot-at ?x ?y_from)))	    
   )


  (:action move-robot-x
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))
		                0.2 (robot-at ?x_from ?y)))
  		 
   )



  (:action move-robot-x-safe
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to)(safety-x ?x_to))
    :effect (and (not (robot-at ?x_from ?y)) (robot-at ?x_to ?y))  		 
   )


 (:action move-robot-y
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to))
    :effect (and (probabilistic 0.8 (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))
		                0.2 (robot-at ?x ?y_from)))
   )

  (:action move-robot-x-safe
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to)(safety-x ?x))
    :effect (and (not (robot-at ?x ?y_from)) (robot-at ?x ?y_to))  		 
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

  ;reduce friction

  (:action design-reduce-friction-x
    :parameters (?x - location ?y - location ?x_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?x ?x_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-x ?x ?y ?x_to)(safety-x ?x_to))
  )


  (:action design-reduce-friction-y
    :parameters (?x - location ?y - location ?y_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?y ?y_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-y ?x ?y ?y_to)(safety-x ?x))
  )

	       

)

(define (domain vacuum-no-fuel-design-over-relaxed)
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
	       (enabled-move-safely-x ?x - location ?y - location ?x_to - location)
	       (enabled-move-safely-y ?x - location ?y - location ?y_to - location)
	       (safety-x ?x - location)
  )

;; enabled actions 

  (:action move-robot-x-enabled
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (prox ?x_from ?x_to) (remove-occupancy-x ?x_from) (occupied ?x_to ?y))
    :effect (and (probabilistic 0.8 (and (robot-at ?x_to ?y))
				0.2 (robot-at ?x_from ?y)))
	    
   )

 (:action move-robot-y-enabled
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (prox ?y_from ?y_to) (remove-occupancy-x ?x) (occupied ?x ?y_to))
    :effect (and(probabilistic 0.8 (and (robot-at ?x ?y_to))
  		               0.2 (robot-at ?x ?y_from)))	    
   )


  (:action move-robot-x
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to))
    :effect (and (probabilistic 0.8 (and (robot-at ?x_to ?y))
		                0.2 (robot-at ?x_from ?y)))
  		 
   )



  (:action move-robot-x-safe
    :parameters (?x_from - location ?x_to - location ?y - location)
    :precondition (and (execution) (robot-at ?x_from ?y) (not (occupied ?x_to ?y)) (prox ?x_from ?x_to)(safety-x ?x_to))
    :effect (and (robot-at ?x_to ?y))  		 
   )


 (:action move-robot-y
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to))
    :effect (and (probabilistic 0.8 (and (robot-at ?x ?y_to))
		                0.2 (robot-at ?x ?y_from)))
   )

  (:action move-robot-x-safe
    :parameters (?x - location ?y_from - location ?y_to - location )
    :precondition (and (execution) (robot-at ?x ?y_from) (not (occupied ?x ?y_to)) (prox ?y_from ?y_to)(safety-x ?x))
    :effect (and (robot-at ?x ?y_to))  		 
   )




 (:action loaddirt
    :parameters (?x_loc - location ?y_loc - location ?dirt -dirt)
    :precondition (and (execution) (robot-at ?x_loc ?y_loc) (dirt-at ?dirt ?x_loc ?y_loc))
    :effect (and (dirt-in-robot ?dirt) ))


 (:action unloaddirt
    :parameters (?x_loc - location ?y_loc - location ?dirt -dirt)
    :precondition (and (execution) (robot-at ?x_loc ?y_loc) (dirt-in-robot ?dirt))
    :effect (and (dirt-at ?dirt ?x_loc ?y_loc)))


 

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

  ;reduce friction

  (:action design-reduce-friction-x
    :parameters (?x - location ?y - location ?x_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?x ?x_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-x ?x ?y ?x_to)(safety-x ?x_to))
  )


  (:action design-reduce-friction-y
    :parameters (?x - location ?y - location ?y_to - location ?t - time ?tnext - time)
    :precondition (and (not (execution)) (next ?t ?tnext) (current-time ?t ) (prox ?y ?y_to))
    :effect (and (current-time ?tnext ) (not (current-time ?t )) (enabled-move-safely-y ?x ?y ?y_to)(safety-x ?x))
  )

	       

)

(define (problem p12)
                   (:domain vacuum-no-fuel)
                   (:objects x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12)
                   (:domain vacuum-no-fuel)
                   (:objects x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-0-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-0-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-0-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-0-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-0-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-1-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-1-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 t2 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-1-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 t2 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-1-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 t2 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-1-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-2-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-2-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 t2 t3 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-2-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 t2 t3 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-2-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 t2 t3 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-2-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-3-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-3-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 t2 t3 t4 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-3-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 t2 t3 t4 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-3-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 t2 t3 t4 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-3-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-4-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 t5 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-4-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 t2 t3 t4 t5 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-4-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 t2 t3 t4 t5 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-4-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 t2 t3 t4 t5 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-4-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 t5 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-5-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 t5 t6 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-5-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 t2 t3 t4 t5 t6 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-5-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 t2 t3 t4 t5 t6 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-5-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 t2 t3 t4 t5 t6 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-5-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 t5 t6 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-6-design)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 t5 t6 t7 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-6-design-relaxed)
                   (:domain vacuum-no-fuel-design-relaxed)
                   (:objects t1 t2 t3 t4 t5 t6 t7 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-6-design-over)
                   (:domain vacuum-no-fuel-design-over)
                   (:objects t1 t2 t3 t4 t5 t6 t7 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-6-design-over-relaxed)
                   (:domain vacuum-no-fuel-design-over-relaxed)
                   (:objects t1 t2 t3 t4 t5 t6 t7 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


(define (problem p12-6-design-tip)
                   (:domain vacuum-no-fuel-design)
                   (:objects t1 t2 t3 t4 t5 t6 t7 - time
 x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 - location 
		              d1 d2 d3 d4 - dirt
		            )
(:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 
(prox x7 x6)(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)(prox x6 x7)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)

;Kitchen island
(occupied x3 y2)
(occupied x3 y3)
(occupied x3 y4)
(occupied x3 y4)
;Arm-charis
(occupied x6 y4)
(occupied x7 y3)


(dirt-at d1 x1 y2)
(dirt-at d2 x4 y3)
(dirt-at d3 x2 y3)
(dirt-at d4 x5 y1)


)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2)(dirt-in-robot d3)(dirt-in-robot d4))) (:goal-reward 100) (:metric maximize (reward)))


