extends Camera

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		self.translation.x -= .5
	if Input.is_action_pressed("ui_right"):
		self.translation.x += .5
	if Input.is_action_pressed("ui_up"):
		self.translation.z -= .5
	if Input.is_action_pressed("ui_down"):
		self.translation.z += .5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

