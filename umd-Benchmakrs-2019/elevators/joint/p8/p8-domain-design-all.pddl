(define (domain elevators-design)
  (:requirements :probabilistic-effects :conditional-effects :negative-preconditions :equality :typing)
  (:types elevator floor pos coin)
  (:constants f1 - floor p1 - pos)
  (:predicates (dec_f ?f ?g - floor) (dec_p ?p ?q - pos) (in ?e - elevator ?f - floor) (at ?f - floor ?p - pos) (shaft ?e - elevator ?p - pos) (inside ?e - elevator) (gate ?f - floor ?p - pos) (coin-at ?c - coin ?f - floor ?p - pos) (have ?c - coin)
(execution)
(current-time ?t - time)
(next ?t1 - time ?t2 - time)	
(enabled-safety-move ?f - floor ?p - pos ?np - pos)
(enabled-add-shaft ?e - elevator ?p - pos)
(add-shaft ?e - elevator)
(safety-move ?f - floor)
)

  (:action enabled-move-left-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution)(enabled-safety-move ?f ?p ?np))
    :effect (probabilistic 0.85 (and (not (at ?f ?p)) (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )
  (:action enabled-move-right-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution)(enabled-safety-move ?f ?p ?np))
    :effect (probabilistic 0.85 (and (not (at ?f ?p)) (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )


 (:action enabled-step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (enabled-add-shaft ?e ?p)(execution))
    :effect (and (inside ?e) (not (at ?f ?p)))
  )
  (:action enabled-step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (enabled-add-shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) (not (inside ?e)))
  )


  (:action go-up
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?nf ?f) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) (not (in ?e ?f)))
  )
  (:action go-down
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?f ?nf) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) (not (in ?e ?f)))
  )
  (:action step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (inside ?e) (not (at ?f ?p)))
  )
  (:action step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) (not (inside ?e)))
  )
  (:action move-left
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution))
    :effect (probabilistic 0.7 (and (not (at ?f ?p)) (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )
  (:action move-right
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution))
    :effect (probabilistic 0.7 (and (not (at ?f ?p)) (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )



  (:action collect
    :parameters (?c - coin ?f - floor ?p - pos)
    :precondition (and (coin-at ?c ?f ?p) (at ?f ?p)(execution))
    :effect (and (have ?c) (not (coin-at ?c ?f ?p)))
  )



;Design actions

 
 (:action design-start-execution
    :parameters ()
    :precondition (not(execution))
    :effect (and (execution))
  )

   (:action design-reduce-uncertainty-move
    :parameters (?f - floor ?p - pos ?np - pos ?t1 - time ?tnext - time)
    :precondition (and (not(execution))(next ?t1 ?tnext)(current-time ?t1 ))
    :effect (and (enabled-safety-move ?f ?p ?np)(safety-move ?f)(current-time ?tnext )(not (current-time ?t1 )))
  )

 (:action design-add-shaft
    :parameters (?e - elevator ?p - pos ?t - time ?tnext - time)
    :precondition (and (not(execution))(next ?t ?tnext)(current-time ?t ))
    :effect (and(current-time ?tnext )(not (current-time ?t ))(enabled-add-shaft ?e ?p )(add-shaft ?e))
  )




)
(define (domain elevators)
  (:requirements :probabilistic-effects :conditional-effects :negative-preconditions :equality :typing)
  (:types elevator floor pos coin)
  (:constants f1 - floor p1 - pos)
  (:predicates (dec_f ?f ?g - floor) (dec_p ?p ?q - pos) (in ?e - elevator ?f - floor) (at ?f - floor ?p - pos) (shaft ?e - elevator ?p - pos) (inside ?e - elevator) (gate ?f - floor ?p - pos) (coin-at ?c - coin ?f - floor ?p - pos) (have ?c - coin))
  (:action go-up
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?nf ?f) (in ?e ?f))
    :effect (and (in ?e ?nf) (not (in ?e ?f)))
  )
  (:action go-down
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?f ?nf) (in ?e ?f))
    :effect (and (in ?e ?nf) (not (in ?e ?f)))
  )
  (:action step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (shaft ?e ?p))
    :effect (and (inside ?e) (not (at ?f ?p)))
  )
  (:action step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (shaft ?e ?p))
    :effect (and (at ?f ?p) (not (inside ?e)))
  )
  (:action move-left
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np))
    :effect (probabilistic 0.7 (and (not (at ?f ?p)) (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )
  (:action move-right
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p))
    :effect (probabilistic 0.7 (and (not (at ?f ?p)) (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )
  (:action collect
    :parameters (?c - coin ?f - floor ?p - pos)
    :precondition (and (coin-at ?c ?f ?p) (at ?f ?p))
    :effect (and (have ?c) (not (coin-at ?c ?f ?p)))
  )
)
(define (domain elevators-design-relaxed)
  (:requirements :probabilistic-effects :conditional-effects :negative-preconditions :equality :typing)
  (:types elevator floor pos coin)
  (:constants f1 - floor p1 - pos)
  (:predicates (dec_f ?f ?g - floor) (dec_p ?p ?q - pos) (in ?e - elevator ?f - floor) (at ?f - floor ?p - pos) (shaft ?e - elevator ?p - pos) (inside ?e - elevator) (gate ?f - floor ?p - pos) (coin-at ?c - coin ?f - floor ?p - pos) (have ?c - coin)
(execution)
(current-time ?t - time)
(next ?t1 - time ?t2 - time)	
(enabled-safety-move ?f - floor ?p - pos ?np - pos)
(enabled-add-shaft ?e - elevator ?p - pos)
(add-shaft ?e - elevator)
(safety-move ?f - floor)
)

  (:action enabled-move-left-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution)(enabled-safety-move ?f ?p ?np))
    :effect (probabilistic 0.85 (and (not (at ?f ?p)) (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )
  (:action enabled-move-right-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution)(enabled-safety-move ?f ?p ?np))
    :effect (probabilistic 0.85 (and (not (at ?f ?p)) (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )


 (:action enabled-step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (enabled-add-shaft ?e ?p)(execution))
    :effect (and (inside ?e) (not (at ?f ?p)))
  )
  (:action enabled-step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (enabled-add-shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) (not (inside ?e)))
  )


  (:action go-up
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?nf ?f) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) (not (in ?e ?f)))
  )
  (:action go-down
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?f ?nf) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) (not (in ?e ?f)))
  )
  (:action step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (inside ?e) (not (at ?f ?p)))
  )
  (:action step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) (not (inside ?e)))
  )
  (:action move-left
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution))
    :effect (probabilistic 0.7 (and (not (at ?f ?p)) (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )
  (:action move-right
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution))
    :effect (probabilistic 0.7 (and (not (at ?f ?p)) (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)(not (at ?f ?p))))))
  )



  (:action collect
    :parameters (?c - coin ?f - floor ?p - pos)
    :precondition (and (coin-at ?c ?f ?p) (at ?f ?p)(execution))
    :effect (and (have ?c) (not (coin-at ?c ?f ?p)))
  )



;Design actions

 (:action design-start-execution
    :parameters ()
    :precondition (not(execution))
    :effect (and (execution))
  )

   (:action design-reduce-uncertainty-move
    :parameters (?f - floor ?p - pos ?np - pos ?t1 - time ?tnext - time)
    :precondition (and (not(execution))(next ?t1 ?tnext)(current-time ?t1 ))
    :effect (and (enabled-safety-move ?f ?p ?np)(safety-move ?f)(current-time ?tnext )(not (current-time ?t1 )))
  )

 (:action design-add-shaft
    :parameters (?e - elevator ?p - pos ?t - time ?tnext - time)
    :precondition (and (not(execution))(next ?t ?tnext)(current-time ?t ))
    :effect (and(current-time ?tnext )(not (current-time ?t ))(enabled-add-shaft ?e ?p )(add-shaft ?e))
  )




)
(define (domain elevators-design-over)
  (:requirements :probabilistic-effects :conditional-effects :negative-preconditions :equality :typing)
  (:types elevator floor pos coin)
  (:constants f1 - floor p1 - pos)
  (:predicates (dec_f ?f ?g - floor) (dec_p ?p ?q - pos) (in ?e - elevator ?f - floor) (at ?f - floor ?p - pos) (shaft ?e - elevator ?p - pos) (inside ?e - elevator) (gate ?f - floor ?p - pos) (coin-at ?c - coin ?f - floor ?p - pos) (have ?c - coin)
(execution)
(current-time ?t - time)
(next ?t1 - time ?t2 - time)	
(enabled-safety-move ?f - floor ?p - pos ?np - pos)
(enabled-add-shaft ?e - elevator ?p - pos)
(add-shaft ?e - elevator)
(safety-move ?f - floor)
)

  (:action enabled-move-left-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution)(enabled-safety-move ?f ?p ?np))
    :effect (probabilistic 0.85 (and  (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )
  (:action enabled-move-right-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution)(enabled-safety-move ?f ?p ?np))
    :effect (probabilistic 0.85 (and  (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )


 (:action enabled-step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (enabled-add-shaft ?e ?p)(execution))
    :effect (and (inside ?e) )
  )
  (:action enabled-step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (enabled-add-shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) )
  )


  (:action go-up
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?nf ?f) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) )
  )
  (:action go-down
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?f ?nf) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) )
  )
  (:action step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (inside ?e) )
  )
  (:action step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) )
  )
  (:action move-left
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution))
    :effect (probabilistic 0.7 (and  (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )
  (:action move-right
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution))
    :effect (probabilistic 0.7 (and  (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )



  (:action collect
    :parameters (?c - coin ?f - floor ?p - pos)
    :precondition (and (coin-at ?c ?f ?p) (at ?f ?p)(execution))
    :effect (and (have ?c) )
  )



;Design actions


 (:action design-start-execution
    :parameters ()
    :precondition (not(execution))
    :effect (and (execution))
  )

   (:action design-reduce-uncertainty-move
    :parameters (?f - floor ?p - pos ?np - pos ?t1 - time ?tnext - time)
    :precondition (and (not(execution))(next ?t1 ?tnext)(current-time ?t1 ))
    :effect (and (enabled-safety-move ?f ?p ?np)(safety-move ?f)(current-time ?tnext )(not (current-time ?t1 )))
  )

 (:action design-add-shaft
    :parameters (?e - elevator ?p - pos ?t - time ?tnext - time)
    :precondition (and (not(execution))(next ?t ?tnext)(current-time ?t ))
    :effect (and(current-time ?tnext )(not (current-time ?t ))(enabled-add-shaft ?e ?p )(add-shaft ?e))
  )




)
(define (domain elevators-design-over-relaxed)
  (:requirements :probabilistic-effects :conditional-effects :negative-preconditions :equality :typing)
  (:types elevator floor pos coin)
  (:constants f1 - floor p1 - pos)
  (:predicates (dec_f ?f ?g - floor) (dec_p ?p ?q - pos) (in ?e - elevator ?f - floor) (at ?f - floor ?p - pos) (shaft ?e - elevator ?p - pos) (inside ?e - elevator) (gate ?f - floor ?p - pos) (coin-at ?c - coin ?f - floor ?p - pos) (have ?c - coin)
(execution)
(current-time ?t - time)
(next ?t1 - time ?t2 - time)	
(enabled-safety-move ?f - floor ?p - pos ?np - pos)
(enabled-add-shaft ?e - elevator ?p - pos)
(add-shaft ?e - elevator)
(safety-move ?f - floor)
)

  (:action enabled-move-left-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution)(safety-move ?f))
    :effect (probabilistic 0.85 (and  (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )
  (:action enabled-move-right-safely
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution)(safety-move ?f))
    :effect (probabilistic 0.85 (and  (at ?f ?np))
                           0.15 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )


 (:action enabled-step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (add-shaft ?e)(execution))
    :effect (and (inside ?e) )
  )
  (:action enabled-step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (add-shaft ?e)(execution))
    :effect (and (at ?f ?p) )
  )


  (:action go-up
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?nf ?f) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) )
  )
  (:action go-down
    :parameters (?e - elevator ?f ?nf - floor)
    :precondition (and (dec_f ?f ?nf) (in ?e ?f)(execution))
    :effect (and (in ?e ?nf) )
  )
  (:action step-in
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (at ?f ?p) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (inside ?e) )
  )
  (:action step-out
    :parameters (?e - elevator ?f - floor ?p - pos)
    :precondition (and (inside ?e) (in ?e ?f) (shaft ?e ?p)(execution))
    :effect (and (at ?f ?p) )
  )
  (:action move-left
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?p ?np)(execution))
    :effect (probabilistic 0.7 (and  (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )
  (:action move-right
    :parameters (?f - floor ?p ?np - pos)
    :precondition (and (at ?f ?p) (dec_p ?np ?p)(execution))
    :effect (probabilistic 0.7 (and  (at ?f ?np))
                           0.3 (and (when (gate ?f ?p) (and (at f1 p1)))))
  )



  (:action collect
    :parameters (?c - coin ?f - floor ?p - pos)
    :precondition (and (coin-at ?c ?f ?p) (at ?f ?p)(execution))
    :effect (and (have ?c) )
  )



;Design actions


 (:action design-start-execution
    :parameters ()
    :precondition (not(execution))
    :effect (and (execution))
  )

   (:action design-reduce-uncertainty-move
    :parameters (?f - floor ?p - pos ?np - pos ?t1 - time ?tnext - time)
    :precondition (and (not(execution))(next ?t1 ?tnext)(current-time ?t1 ))
    :effect (and (enabled-safety-move ?f ?p ?np)(safety-move ?f)(current-time ?tnext )(not (current-time ?t1 )))
  )

 (:action design-add-shaft
    :parameters (?e - elevator ?p - pos ?t - time ?tnext - time)
    :precondition (and (not(execution))(next ?t ?tnext)(current-time ?t ))
    :effect (and(current-time ?tnext )(not (current-time ?t ))(enabled-add-shaft ?e ?p )(add-shaft ?e))
  )




)
(define (problem p8)
  (:domain elevators)
  (:objects f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8)
  (:domain elevators)
  (:objects f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-0-design)
  (:domain elevators-design)
  (:objects t1 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-0-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-0-design-over)
  (:domain elevators-design-over)
  (:objects t1 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-0-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-0-design-tip)
  (:domain elevators-design)
  (:objects t1 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-1-design)
  (:domain elevators-design)
  (:objects t1 t2 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-1-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 t2 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-1-design-over)
  (:domain elevators-design-over)
  (:objects t1 t2 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-1-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 t2 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-1-design-tip)
  (:domain elevators-design)
  (:objects t1 t2 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-2-design)
  (:domain elevators-design)
  (:objects t1 t2 t3 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-2-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 t2 t3 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-2-design-over)
  (:domain elevators-design-over)
  (:objects t1 t2 t3 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-2-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 t2 t3 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-2-design-tip)
  (:domain elevators-design)
  (:objects t1 t2 t3 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-3-design)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-3-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 t2 t3 t4 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-3-design-over)
  (:domain elevators-design-over)
  (:objects t1 t2 t3 t4 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-3-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 t2 t3 t4 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-3-design-tip)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-4-design)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 t5 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-4-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 t2 t3 t4 t5 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-4-design-over)
  (:domain elevators-design-over)
  (:objects t1 t2 t3 t4 t5 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-4-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 t2 t3 t4 t5 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-4-design-tip)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 t5 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-5-design)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 t5 t6 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-5-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 t2 t3 t4 t5 t6 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-5-design-over)
  (:domain elevators-design-over)
  (:objects t1 t2 t3 t4 t5 t6 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-5-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 t2 t3 t4 t5 t6 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-5-design-tip)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 t5 t6 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-6-design)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 t5 t6 t7 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-6-design-relaxed)
  (:domain elevators-design-relaxed)
  (:objects t1 t2 t3 t4 t5 t6 t7 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-6-design-over)
  (:domain elevators-design-over)
  (:objects t1 t2 t3 t4 t5 t6 t7 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-6-design-over-relaxed)
  (:domain elevators-design-over-relaxed)
  (:objects t1 t2 t3 t4 t5 t6 t7 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
(define (problem p8-6-design-tip)
  (:domain elevators-design)
  (:objects t1 t2 t3 t4 t5 t6 t7 - time
 f2 f3 - floor p2 p3 p4 p5 p6 p7 p8 - pos e1 e2 - elevator c1 c2 c3 c4 c5 c6 - coin)
  (:init (current-time t1)(next t1 t2)(next t2 t3)(next t3 t4)(next t4 t5)(next t5 t6)(next t6 t7)
 (at f1 p1) (dec_f f2 f1) (dec_f f3 f2) (dec_p p2 p1) (dec_p p3 p2) (dec_p p4 p3) (dec_p p5 p4) (dec_p p6 p5) (dec_p p7 p6) (dec_p p8 p7) (shaft e1 p1) (in e1 f1) (shaft e2 p5) (in e2 f1) (coin-at c1 f3 p5) (coin-at c2 f3 p1) (coin-at c3 f1 p7) (coin-at c4 f2 p6) (coin-at c5 f2 p7) (coin-at c6 f2 p1) (gate f2 p5) (gate f2 p7) (gate f3 p8))
  (:goal (and (have c1) (have c2) (have c3) (have c4) (have c5) (have c6)))
)
