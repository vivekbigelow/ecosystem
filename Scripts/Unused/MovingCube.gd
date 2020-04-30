extends KinematicBody

var velocity = Vector3(0,0,0)

var speed = 10
const TIME_PERIOD = 1
var time = -1
func _ready():
	translation.x = 25
	translation.z = 25

func _physics_process(delta):


	translation.y = sin(PI * time)
	time += delta
	
	if time > TIME_PERIOD:
		print("HERE")
		time = -1
		
	
	print(velocity)
	#move_and_slide(velocity * speed)
	#velocity = Vector3(10, sin(delta + 1) + 10, 10)
	
	
	
	
		
	#print(self.translation)
	
