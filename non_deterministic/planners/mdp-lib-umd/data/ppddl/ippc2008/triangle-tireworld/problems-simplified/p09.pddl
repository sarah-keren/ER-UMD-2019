(define (problem p09)
                   (:domain triangle-tire)
                   (:objects l-1-1 l-1-2 l-1-3 l-2-1 l-2-2 l-2-3 l-3-1 l-3-2 l-3-3 - location)
                   (:init (vehicle-at l-3-3)(road l-1-1 l-1-2)(road l-1-2 l-1-3)(road l-1-1 l-2-1)(road l-1-2 l-2-2)(road l-2-1 l-1-2)(road l-2-2 l-1-3)(spare-in l-2-1)(spare-in l-2-2)(road l-2-1 l-3-1)(road l-3-1 l-2-2)(spare-in l-3-1)(not-flattire))
                   (:goal (vehicle-at l-1-3)) (:goal-reward 100) (:metric maximize (reward)))

