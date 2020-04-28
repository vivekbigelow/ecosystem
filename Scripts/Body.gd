extends KinematicBody

var velocity = Vector3()
var speed = .25

var rotate_speed = 0.1
var jumping = false
var jump_speed = 5

var mouse_sens = 0.3
var camera_anglev=0
func _ready():
	pass

func _physics_process(delta):
	velocity.y = 0
	velocity.x = 0
	velocity.z = 0
	
	if Input.is_action_pressed("fwd"):
		velocity += -transform.basis.z
	if Input.is_action_pressed("back"):
		velocity += transform.basis.z
	if Input.is_action_pressed("right"):
		velocity += transform.basis.x
	if Input.is_action_pressed("left"):
		velocity += -transform.basis.x
	
	
	move_and_collide(velocity * speed)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x*mouse_sens))
		
		
	

