extends KinematicBody

const DISTANCE_THRESHOLD = 3.0
const SLOW_RADIUS = 10.0
const PANIC_DISTANCE = 5.0

export var max_speed := 7.0
var velocity := Vector3(0,0,0)
var global_position := self.get_translation()
onready var terrain = self.get_node("../Terrain")
onready var plant_target = self.find_plant()

func find_plant()->Vector3:
	for i in range(terrain.tileArray.size()):
		if terrain.tileArray[i].get_tile_type() == "tree":
			return terrain.tileArray[i].position
	return Vector3(0,0,0)
	
func _physics_process(delta: float) -> void:
	var target_global_position = plant_target
	
	print("target: " ,target_global_position)
	
	
	velocity = Steering.arrive(
			velocity,
			global_position,
			target_global_position,
			max_speed
			
	)
	
	
	move_and_slide(velocity)
	global_position = self.get_translation()
	print("position: " ,global_position)
	
	

