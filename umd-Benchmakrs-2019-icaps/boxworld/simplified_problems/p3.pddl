(define
 (problem p3)
  (:domain boxworld)
  (:objects box0 - box
            box1 - box
            box2 - box
            truck0 - truck
            ;;;truck1 - truck
            plane0 - plane
            ;;;plane1 - plane
            city0 - city
            city1 - city
            city2 - city
            city3 - city
  )
  (:init (box-at-city box0 city1)
         (destination box0 city2)
         (box-at-city box1 city2)
         (destination box1 city0)
         (box-at-city box2 city2)
         (destination box2 city0)
         (truck-at-city truck0 city0)
         (truck-at-city truck1 city0)
         (plane-at-city plane0 city0)
         (plane-at-city plane1 city1)
         (can-drive city0 city1)
         (can-drive city0 city2)
         (can-drive city0 city3)
         (wrong-drive1 city0 city1)
         (wrong-drive2 city0 city2)
         (can-fly city0 city1)
         (can-drive city1 city0)
         (can-drive city1 city2)
         (can-drive city1 city3)
         (wrong-drive1 city1 city0)
         (wrong-drive2 city1 city2)
         (can-fly city1 city0)
         (can-drive city2 city0)
         (can-drive city2 city1)
         (can-drive city2 city3)
         (wrong-drive1 city2 city0)
         (wrong-drive2 city2 city1)
         (can-drive city3 city0)
         (can-drive city3 city1)
         (can-drive city3 city2)
         (wrong-drive1 city3 city0)
         (wrong-drive2 city3 city1)
  )
  (:goal 
	
         (box-at-city box2 city0)
  )
  (:goal-reward 1)
  (:metric maximize (reward))
)
