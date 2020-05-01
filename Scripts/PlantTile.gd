extends Tile

class_name PlantTile

func init(positionVector = Vector3(0,0,0)):
	.init(positionVector)
	tiletype = "plant"
	
	

func get_tile_type()->String:
	return .get_tile_type()


func _ready():
	pass



