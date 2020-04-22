extends Spatial

class_name Terrain

var noise = OpenSimplexNoise.new()
var tileArray = []
var GrassTileScene = preload("res://Scenes/GrassTile.tscn")
var WaterTileScene = preload("res://Scenes/WaterTile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_terrain(50,50)
	
#generate the terrain using simplex noise
#width refers to x and height refers to z

func generate_terrain(width,height):
	noise.seed = randi()
	noise.lacunarity = 1.5
	noise.octaves = 4
	noise.period = rand_range(15,20)
	noise.persistence = 0.9
	
	for y in range(1):
		for x in range(width):
			for z in range(height):
				if 5 > noise.get_noise_2d(x,z) * 5 + 5:
					var position = Vector3(x,y+0.5,z)
					generate_tile(0,position)
				else:
					var position = Vector3(x,y,z)
					generate_tile(1,position)
	

#make the tiles that will be added to the scene
#pass a the tile type and position to be created
func generate_tile(type, position):
	var tile
	
	#Grass tile
	if type == 0:
		tile = GrassTileScene.instance()
		tile.translate(position)
		
		tileArray.append(tile)
	#Water tile
	elif type == 1:
		tile = WaterTileScene.instance()
		tile.translate(position)
		
		tileArray.append(tile)
	else:
		print_debug("No tile type specified")
		
	#add the tile to the Terrain scene	
	self.add_child(tile)
	
	
	
		