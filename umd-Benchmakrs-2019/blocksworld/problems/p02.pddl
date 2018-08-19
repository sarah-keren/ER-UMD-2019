(define (problem p02)
  (:domain blocks-domain)
  (:objects b1 b2 b3 b4 b5 - block t1 t2 t3 t4 - time)
  (:init (current-time t2) (next t1 t2) (next t2 t3) (next t3 t4) (initialization) (emptyhand) (on-table b1) (on-table b2) (on b3 b5) (on b4 b1) (on-table b5) (clear b2) (clear b3) (clear b4))
  (:goal (and (emptyhand) (on b1 b3) (on b2 b4) (on-table b3) (on b4 b1) (on b5 b2) (clear b5)))
  (:goal-reward 20)
  (:metric maximize (reward))
)
