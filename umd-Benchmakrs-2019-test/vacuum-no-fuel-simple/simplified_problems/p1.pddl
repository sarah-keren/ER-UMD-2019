(define (problem p1)
                   (:domain vacuum-no-fuel)
                   (:objects x1 x2 y1 y2 - location 
		              d1 - dirt)
(:init 
(prox x2 x1)
(prox x1 x2)
(prox y1 y2)
(prox y2 y1)

(robot-at x1 y1)

(occupied x1 y2)
(occupied x2 y1)

(dirt-at d1 x1 y2)

)
(:goal (and  (dirt-in-robot d1))) (:goal-reward 100) (:metric maximize (reward)))


