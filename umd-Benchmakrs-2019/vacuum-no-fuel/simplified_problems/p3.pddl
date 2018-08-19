(define (problem p3)
                   (:domain vacuum-no-fuel)
                   (:objects x1 x2 x3 y1 y2 y3 - location 
		              d1 d2  - dirt )
(:init 
(prox x3 x2)(prox x2 x1)
(prox x1 x2)(prox x2 x3)
(prox y1 y2)(prox y2 y3)
(prox y3 y2)(prox y2 y1)

(robot-at x1 y1)


(occupied x2 y2)
(occupied x3 y3)


(dirt-at d1 x1 y1)
(dirt-at d2 x3 y2)
)

(:goal (and  (dirt-in-robot d1)(dirt-in-robot d2))) (:goal-reward 100) (:metric maximize (reward)))


