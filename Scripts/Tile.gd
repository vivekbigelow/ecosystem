extends Spatial

class_name Tile

var tiletype
var position = Vector3()


func init(positionVector = Vector3(0,0,0)):
	position = positionVector
	self.translate(position)
	
	
	

func get_tile_type()->String:
	return tiletype

func _ready():
	pass

