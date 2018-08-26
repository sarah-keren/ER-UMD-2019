(define (problem p1)
                   (:domain vacuum-no-fuel)
                   (:objects x1 x2 x3 x4 x5 x6 y1 y2 y3 y4 y5 y6 y7 y8 - location 
		              d1 - dirt)
(:init 
(prox x6 x5)(prox x5 x4)(prox x4 x3)(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)(prox x3 x4)(prox x4 x5)(prox x5 x6)
(prox y1 y2)(prox y2 y3)(prox y3 y4)
(prox y4 y3)(prox y3 y2)(prox y2 y1)
(prox y4 y5)(prox y5 y6)(prox y6 y7)(prox y7 y8)
(prox y5 y4)(prox y6 y5)(prox y7 y6)(prox y8 y7)



(robot-at x1 y1)

(occupied x1 y2)
(occupied x1 y3)

(occupied x2 y2)
(occupied x2 y3)

(occupied x3 y2)
(occupied x3 y3)

(occupied x4 y2)


(dirt-at d1 x3 y4)


)

(:goal (and  (dirt-in-robot d1))) (:goal-reward 100) (:metric maximize (reward)))

