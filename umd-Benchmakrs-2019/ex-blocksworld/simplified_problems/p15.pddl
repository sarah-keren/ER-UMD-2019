(define (problem p15)
  (:domain exploding-blocksworld)
  (:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 - block)
  (:init (emptyhand) (on b1 b5) (on b2 b9) (on-table b3) (on b4 b6) (on b5 b2) (on-table b6) (on b7 b8) (on b8 b1) (on b9 b3) (on-table b10) (clear b4) (clear b7) (clear b10)


(no-detonated b1) (no-destroyed b1) (no-detonated b2) (no-destroyed b2) (no-detonated b3) (no-destroyed b3) (no-detonated b4) (no-destroyed b4) (no-detonated b5) (no-destroyed b5) (no-detonated b6) (no-destroyed b6)(no-detonated b7) (no-destroyed b7) (no-detonated b8) (no-destroyed b8) (no-detonated b9) (no-destroyed b9) (no-detonated b10) (no-destroyed b10)(no-destroyed-table)
)
  (:goal (and (emptyhand) (on b10 b1) (on b2 b6) (on b3 b8) (on b4 b2) (on-table b5) (on-table b6) (on b7 b5) (on-table b8) (on b9 b3) (on b1 b4) (clear b10) (clear b7) (clear b9)))
  (:goal-reward 1)
  (:metric maximize (reward))
)
