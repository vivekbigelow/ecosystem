extends Spatial

class_name Terrain

var noise = OpenSimplexNoise.new()
var grassTiles = []
var waterTiles = []
var plantTiles = []
var treeTiles = []
var walkable 
var walkableTiles
var isWater
var walkableNeighborsMatrix
var isShore
var isFood
var isFoodNeighbor

var size


var GrassTileScene = preload("res://Scenes/GrassTile.tscn")
var WaterTileScene = preload("res://Scenes/WaterTile.tscn")
var TreeTileScene = preload("res://Scenes/TreeTile.tscn")
var PlantTileScene = preload("res://Scenes/PlantTile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
#generate the terrain using simplex noise
#width refers to x and height refers to z

func init(size)->void:
	randomize()
	self.size = size
	walkable = AutoLoads.new_2d_array(size,size,false)
	isWater = AutoLoads.new_2d_array(size,size,false)
	isFood = AutoLoads.new_2d_array(size,size,false)
	#test_generate(size,size)
	generate_terrain(size,size)
	walkableTiles = walkable_tiles()
	find_walkable_neighbors()
	find_shore_tiles()
	find_food_neighbor_tiles()
	
func test_generate(width,height):
	
	for z in range(height):
		for x in range(width):
			var position = Vector3(x,0,z)
			generate_tile(0,position)
			walkable[x][z] = true
				
func generate_terrain(width,height):
	noise.seed = randi()
	noise.lacunarity = 1.5
	noise.octaves = 4
	noise.period = rand_range(15,20)
	noise.persistence = 0.9
	
	
	for z in range(height):
		for x in range(width):
			var noiseNumber = noise.get_noise_2d(x,z) * 5 + 5
			var randomNumber = rand_range(0,3)
			
			if 5 > noiseNumber:
				var position = Vector3(x,0,z)
					
				if randomNumber < 0.1:
					generate_tile(1,position)
					
				elif randomNumber > 0.1 and randomNumber < .5:
					generate_tile(2,position)
					isFood[x][z] = true
						
				else:
					generate_tile(0,position)
					walkable[x][z] = true
			else:
				var position = Vector3(x,0,z)
				generate_tile(3,position)
				isWater[x][z] = true
	
	
	

#make the tiles that will be added to the scene
#pass a the tile type and position to be created

	
func generate_tile(type : int, position: Vector3):
	var tile
	
	#Grass tile
	if type == 0:
		tile = GrassTileScene.instance()
		tile.init(position)
		#tile.translate(position)
		grassTiles.append(tile)
	#Tree Tile
	elif type == 1:
		tile = TreeTileScene.instance()
		tile.init(position)
		treeTiles.append(tile)
	#Plant tile
	elif type == 2:
		tile = PlantTileScene.instance()
		tile.init(position)
		plantTiles.append(tile)
	#Water Tile
	elif type == 3:
		tile = WaterTileScene.instance()
		tile.init(position)
		waterTiles.append(tile)
	else:
		print_debug("No tile type specified")
		
	#add the tile to the Terrain scene	
	self.add_child(tile)
	
func find_walkable_neighbors()->void:
	walkableNeighborsMatrix = AutoLoads.new_2d_array(size,size,false)
	for z in range(size):
		for x in range(size):
			if walkable[x][z]:
				var walkableNeighbors = []
				for offsetZ in range(-1,2):
					for offsetX in range(-1,2):
						#print("offsetX: ", offsetX, "offsetZ: ", offsetZ)
						if (offsetX != 0 or offsetZ != 0):
							var neighborX = x + offsetX
							var neighborZ = z + offsetZ
							if (neighborX >= 0 and neighborX < size and neighborZ >= 0 and neighborZ < size):
								if walkable[neighborX][neighborZ]:
									walkableNeighbors.append(Vector2(neighborX,neighborZ))
				walkableNeighborsMatrix[x][z] = walkableNeighbors
	
func walkable_tiles():
	var walkableTiles = []
	for z in range(size):
		for x in range(size):
			if walkable[x][z]:
				walkableTiles.append(Vector2(x,z))
	return walkableTiles	
	
func find_shore_tiles()->void:
	isShore = AutoLoads.new_2d_array(size,size,false)
	for z in range(size):
		for x in range(size):
			if isWater[x][z]:
				for offsetZ in range(-1,1):
					for offsetX in range(-1,1):
						if (offsetX != 0 or offsetZ != 0):
							var neighborX = x + offsetX
							var neighborZ = z + offsetZ
							if (neighborX >= 0 and neighborX < size and neighborZ >= 0 and neighborZ < size):
								if walkable[neighborX][neighborZ]:
									isShore[neighborX][neighborZ] = true
									
func find_food_neighbor_tiles()->void:
	isFoodNeighbor= AutoLoads.new_2d_array(size,size,false)
	for z in range(size):
		for x in range(size):
			if isFood[x][z]:
				for offsetZ in range(-1,1):
					for offsetX in range(-1,1):
						if (offsetX != 0 or offsetZ != 0):
							var neighborX = x + offsetX
							var neighborZ = z + offsetZ
							if (neighborX >= 0 and neighborX < size and neighborZ >= 0 and neighborZ < size):
								if walkable[neighborX][neighborZ]:
									isFoodNeighbor[neighborX][neighborZ] = true
									
	
		