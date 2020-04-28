extends KinematicBody

var velocity = Vector3()
var speed := 4.0
var hunger
var thirst
var age
var global_position := self.get_translation()
var currentState

func init() -> void:
	hunger = 10
	thirst = 10
	age = 1
	currentState = born

	
func update() -> void:
	hunger -= 1
	thirst -= 1
	age += 1
	
	if hunger <= 5:
		currentState = hungry
	if thirst <= 5:
		currentState = thirsty
	if age >= 10:
		currentState = dead
		
func _physics_process(delta) -> void:
	

#current tile the entity is on





