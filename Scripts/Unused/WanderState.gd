extends State

class_name WanderState

var animal 

func init(creature):
	animal = creature
	
func enter():
	animal.wander()
func update():
	animal.wander()
func exit():
	print("Stopping Wander")


