extends Tile

class_name GrassTile

func init(positionVector = Vector3(0,0,0)):
	.init(positionVector)
	tiletype = "grass"

func get_tile_type()->String:
	return .get_tile_type()

func _ready():
	
	pass # Replace with function body.

