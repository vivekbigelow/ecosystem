extends KinematicBody
var velocity = Vector3(0,-1,0)
var speed = 7
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _physics_process(delta):
	move_and_slide(velocity*speed)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
