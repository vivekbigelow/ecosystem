extends Spatial

class_name Tile

var tiletype


func _inti():
	tiletype = "default"

func get_tile_type()->String:
	return tiletype

func _ready():
	pass # Replace with function body.

