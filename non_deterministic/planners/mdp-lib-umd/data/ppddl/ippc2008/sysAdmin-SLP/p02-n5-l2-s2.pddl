(define (problem sysadmin-5-2-2)
  (:domain sysadmin-slp)
  (:objects comp0 comp1 comp2 comp3 comp4 - comp)
  (:init
	 (conn comp0 comp1)
	 (conn comp0 comp3)
	 (conn comp1 comp2)
	 (conn comp2 comp3)
	 (conn comp3 comp2)
	 (conn comp3 comp4)
	 (conn comp4 comp0)
  )
  (:goal (forall (?c - comp)
                 (up ?c)))
  (:goal-reward 500)
 (:metric maximize (reward))
)
