(define (problem p6)
  (:domain elevators)
  (:objects f2 f3 - floor p2 p3 p4 - pos e1 e2 - elevator c1 c2 c3 - coin)
  (:init (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (shaft e1 p2) (in e1 f3) (shaft e2 p2) (in e2 f2) (coin-at c1 f3 p2) (coin-at c2 f2 p2) (coin-at c3 f1 p4) (gate f2 p3) (gate f3 p4))
  (:goal (and (have c2)))
)
