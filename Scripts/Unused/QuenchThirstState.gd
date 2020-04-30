extends State

class_name QuenchThirstState

var animal 
var neighbors

func init(creature):
	animal = creature
	
func enter():
	animal.find_water()
func update():
	animal.get_neighbors()
	for i in range (animal.neighbors.size()):
		for j in range (animal.terrain.waterTiles.size()):
			if animal.neighbors[i] == animal.terrain.waterTiles[j].position:
				animal.drink()
			else:
				animal.go_to_water()
	
func exit():
	print("Animal Has quenched thirst")
