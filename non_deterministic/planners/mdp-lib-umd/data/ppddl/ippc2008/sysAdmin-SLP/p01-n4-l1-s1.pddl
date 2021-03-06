(define (problem sysadmin-4-1-1)
  (:domain sysadmin-slp)
  (:objects comp0 comp1 comp2 comp3 - comp)
  (:init
	 (conn comp0 comp1)
	 (conn comp1 comp2)
	 (conn comp2 comp3)
	 (conn comp3 comp0)
	 (conn comp3 comp1)
  )
  (:goal (forall (?c - comp)
                 (up ?c)))
  (:goal-reward 500)
 (:metric maximize (reward))
)
