(define (problem p02)
  (:domain elevators)
  (:objects f2 f3 - floor p2 p3 p4 - pos e1 e2 - elevator c1 c2 c3 - coin  t1 t2 t3 - time)
  (:init (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (shaft e1 p2) (in e1 f1) (shaft e2 p3) (in e2 f1) (coin-at c1 f2 p1) (coin-at c2 f2 p1) (coin-at c3 f2 p2) (gate f2 p3))
  (:goal (and (have c1) (have c2) (have c3)))
)