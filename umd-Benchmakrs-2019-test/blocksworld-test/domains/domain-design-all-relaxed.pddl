(define (domain blocks-domain-design-relaxed)
  (:requirements :probabilistic-effects :conditional-effects :equality :typing :rewards)
  (:types block time)
  (:predicates (holding ?b - block) (emptyhand) (on-table ?b - block) (on ?b1 ?b2 - block) (clear ?b - block)
	(enabled-safety-pickup-tower ?b1 ?b2 ?b3 - block)
	(enabled-safety-pickup ?b - block)
	(safety-pickup)
	(safety-pickup-tower)
	(execution)
	(current-time ?t - time)
	(next ?t1 - time ?t2 - time)	
	(enabled-put-on-table ?b - block)	
)

  (:action pick-tower-safely
    :parameters (?b1 ?b2 ?b3 - block)
    :precondition (and (emptyhand) (clear ?b1) (on ?b1 ?b2) (on ?b2 ?b3)(execution)(enabled-safety-pickup-tower ?b1 ?b2 ?b3))
    :effect (and (holding ?b2) (clear ?b3) )
  )


 (:action pick-up-safely
    :parameters (?b1 ?b2 - block)
    :precondition (and (emptyhand) (clear ?b1) (on ?b1 ?b2)(enabled-safety-pickup ?b1)(execution))
    :effect
      (and (holding ?b1) (clear ?b2)  (not (on ?b1 ?b2))
      )
  )
  (:action pick-up-from-table-safely
    :parameters (?b - block)
    :precondition (and (emptyhand) (clear ?b) (on-table ?b)(enabled-safety-pickup ?b)(execution))
    :effect (and (holding ?b)  )
  )

  (:action pick-up-a
    :parameters (?b1 ?b2 - block)
    :precondition (and (emptyhand) (clear ?b1) (on ?b1 ?b2)(execution))
    :effect
         (and (holding ?b1) (clear ?b2)  (not (on ?b1 ?b2)))

  )
  (:action pick-up-b
    :parameters (?b1 ?b2 - block)
    :precondition (and (emptyhand) (clear ?b1) (on ?b1 ?b2)(execution))
    :effect (and (clear ?b2) (on-table ?b1) (not (on ?b1 ?b2)))
  )


  (:action pick-up-from-table
    :parameters (?b - block)
    :precondition (and (emptyhand) (clear ?b) (on-table ?b)(execution))
    :effect (and (holding ?b)  )
  )
  (:action put-on-block-a
    :parameters (?b1 ?b2 - block)
    :precondition (and (holding ?b1) (clear ?b1) (clear ?b2) (not (= ?b1 ?b2))(execution))
    :effect (and (on ?b1 ?b2) (emptyhand) (clear ?b1) (not (holding ?b1)) (not (clear ?b2)))

  )

  (:action put-on-block-b
    :parameters (?b1 ?b2 - block)
    :precondition (and (holding ?b1) (clear ?b1) (clear ?b2) (not (= ?b1 ?b2))(execution))
    :effect (and (on-table ?b1) (emptyhand) (clear ?b1) (not (holding ?b1)))
  )

  (:action put-down
    :parameters (?b - block)
    :precondition (and (holding ?b) (clear ?b)(execution))
    :effect (and (on-table ?b) (emptyhand) (clear ?b) (not (holding ?b)))
  )
  (:action pick-tower
    :parameters (?b1 ?b2 ?b3 - block)
    :precondition (and (emptyhand) (clear ?b1) (on ?b1 ?b2) (on ?b2 ?b3)(execution))
    :effect (and (holding ?b2) (clear ?b3) )
  )
  (:action put-tower-on-block-a
    :parameters (?b1 ?b2 ?b3 - block)
    :precondition (and (holding ?b2) (on ?b1 ?b2) (clear ?b3) (not (= ?b1 ?b3))(execution))
    :effect (and (on ?b2 ?b3) (emptyhand) (not (holding ?b2)) (not (clear ?b3)))
  )

  (:action put-tower-on-block-b
    :parameters (?b1 ?b2 ?b3 - block)
    :precondition (and (holding ?b2) (on ?b1 ?b2) (clear ?b3) (not (= ?b1 ?b3))(execution))
    :effect (and (on-table ?b2) (emptyhand) (not (holding ?b2)))
  )


  (:action put-tower-down
    :parameters (?b1 ?b2 - block)
    :precondition (and (holding ?b2) (on ?b1 ?b2)(execution))
    :effect (and (on-table ?b2) (emptyhand) (not (holding ?b2)))
  )


;Design actions



  (:action design-start-execution
    :parameters ()
    :precondition (and (not (execution)))
    :effect (and (execution))
  )

   (:action design-reduce-uncertainty-pickup-tower
    :parameters (?b1 ?b2 ?b3 - block ?t - time ?tnext - time)
    :precondition (and (not (execution))(next ?t ?tnext)(current-time ?t ))
    :effect (and (enabled-safety-pickup-tower ?b1 ?b2 ?b3 )(safety-pickup-tower)(current-time ?tnext )(not (current-time ?t )))
  )

  (:action design-reduce-uncertainty-pickup
    :parameters (?b - block ?t - time ?tnext - time)
    :precondition (and (not (execution))(next ?t ?tnext)(current-time ?t ))
    :effect (and (enabled-safety-pickup ?b )(safety-pickup)(current-time ?tnext )(not (current-time ?t )))
  )

 (:action design-put-on-table
    :parameters (?b1 - block ?b2 - block ?t - time ?tnext - time)
    :precondition (and (not (execution))(next ?t ?tnext)(current-time ?t )(on ?b1 ?b2))
    :effect (and (enabled-put-on-table ?b1)(on-table ?b1)(clear ?b2)(current-time ?tnext )(not (current-time ?t )))
  )

)

