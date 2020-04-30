extends Spatial

class_name GameWorld

var TerrainScene = preload("res://Scenes/Terrain.tscn")
var terrainGenerator : Terrain
var AnimalScene = preload("res://Scenes/Rabbit.tscn")
var size
var walkable 
var walkableNeighborsMatrix
var walkableTiles = []
var isShore
var isFood
var isFoodNeighbor
var shoreTiles = []
var foodTiles = []
var closestVisibleShoreMatrix
var maxViewDistance = 40 #Animal max view


func _ready()->void:
	pass

func RegisterDeath(entity)->void:
	print(entity," ", "is Dead")
	entity.queue_free()
	
func get_next_tile_random(current : Vector2)->Vector2:
	#print(walkableNeighborsMatrix)
	
	if !walkableNeighborsMatrix[current.x][current.y]:
		return current
	else:
		var neighbors = walkableNeighborsMatrix[current.x][current.y]
		if neighbors.empty():
			return current
		else:
			return neighbors[rand_range(0,neighbors.size())]

func SenseWater (position : Vector2):
	var index = rand_range(0,shoreTiles.size())
	var tile = shoreTiles[index]
	if isShore[tile.x][tile.y]:
		return tile
	else:
		return position

func SenseFood (position : Vector2):
	var index = rand_range(0,foodTiles.size())
	var tile = foodTiles[index]
	if isFoodNeighbor[tile.x][tile.y]:
		return tile
	else:
		return position

	
		

func spawnInitialPopulation():
	var initialNum = rand_range(1,10)
	var walkableTilesCopy = walkableTiles
	
	for i in range(initialNum):
		var index = rand_range(0,walkableTilesCopy.size())
		var position = walkableTiles[index]
		var animal = AnimalScene.instance()
		animal.init(position,self)
		self.add_child(animal)
		walkableTilesCopy.remove(index)
		

	

	
func init(size)->void:
	
	#Create Terrain
	terrainGenerator = TerrainScene.instance()
	self.size = size
	terrainGenerator.init(size)
	self.add_child(terrainGenerator)
	
	walkable = terrainGenerator.walkable
	#print("GameWorld" , terrainGenerator.walkableNeighborsMatrix)
	walkableNeighborsMatrix = terrainGenerator.walkableNeighborsMatrix
	walkableTiles = terrainGenerator.walkableTiles
	isShore = terrainGenerator.isShore
	isFood = terrainGenerator.isFood
	isFoodNeighbor = terrainGenerator.isFoodNeighbor
	
				
	var viewOffsets = []
	var viewRadius = maxViewDistance
	var sqrViewRadius = viewRadius * viewRadius
	for offSetZ in range(-viewRadius,viewRadius):
		for offSetX in range(-viewRadius, viewRadius):
			var sqrOffsetDistance = offSetX * offSetX + offSetZ * offSetZ
			if ((offSetX != 0 or offSetZ != 0) and sqrOffsetDistance <= sqrViewRadius):
				viewOffsets.append(Vector2(offSetX,offSetZ))
	viewOffsets.sort_custom(self, "Vector2Compare")
	
	closestVisibleShoreMatrix = AutoLoads.new_2d_array(size,size,false)
	for z in range(size):
		for x in range(size):
			var foundShore = false
			if walkable[x][z]:
				for i in range(viewOffsets.size()):
					var targetX = x + viewOffsets[i].x
					var targetZ = z + viewOffsets[i].y
					if (targetX >= 0 and targetX < size and targetZ >= 0 and targetZ < size):
						if isShore[targetX][targetZ]:
							if TileIsVisible(x,z,targetX,targetZ):
								closestVisibleShoreMatrix[x][z]= Vector2(targetX,targetZ)
								foundShore = true
								break
								
	#print(closestVisibleShoreMatrix)
	for i in range(walkableTiles.size()):
		var tile = walkableTiles[i]
		if isShore[tile.x][tile.y]:
			shoreTiles.append(tile)
		if isFoodNeighbor[tile.x][tile.y]:
			foodTiles.append(tile)
			
	spawnInitialPopulation()

			
							
						
	

	
#Utility Functions

func CheckNeighbors (position : Vector2, target : Vector2):
	return ((abs(position.x - target.x) <= 1) and (abs(position.y - target.y) <= 1))
	
func Vector2Compare(a,b):
	return (a.x * a.x + a.y * a.y) < (b.x * b.x + b.y * b.y)
	
func TileIsVisible (x : int, z : int, x2 : int, z2: int):
	#bresenham line algorithm
	var w = x2 - x
	var h = z2 - z
	var absW = abs(w)
	var absH = abs(h)
	
	#Neighboring Tile
	if (absW <= 1 and absH <= 1):
		return true
	
	var dx1 = 0
	var dz1 = 0
	var dx2 = 0
	var dz2 = 0
	
	if w < 0:
		dx1 = -1
		dx2 = -1
	elif w > 0:
		dx1 = 1 
		dx2 = 1
	if h < 0:
		dz1 = -1
	elif h > 0:
		dz1 = 1
		
	var longest = absW
	var shortest = absH
	if longest <= shortest:
		longest = absH
		shortest = absW
		if h < 0:
			dz2 = -1
		elif h > 0:
			dz2 = 1
		dx2 = 0
		
	var numerator = longest >> 1
	for i in range(longest):
		numerator += shortest
		if numerator >= longest:
			numerator -= longest
			x += dx1
			z += dz1
		else:
			x += dx2
			z += dz2
		
		if (!walkable[z][x]):
			return false
	return true
	
	
func GetPath (start : Vector2, end : Vector2):
	var path = []
	path.append(end)
	return path
	
	#Doesn't work
	
	#bresenham line alg.
	var x = start.x
	var y = start.y
	var x2 = end.x
	var y2 = end.y
	
	var w = x2 - x
	var h = y2 - y
	var absW = int(abs(w))
	var absH = int(abs(h))
	
	
	
	if (absW <= 1 and absH <= 1):
		path.append(end)
		return path
	
	var dx1 = 0
	var dy1 = 0
	var dx2 = 0
	var dy2 = 0
	
	if (w < 0):
		dx1 = -1
		dx2 = -1
	elif w > 0:
		dx1 = 1
		dx2 = 1
	
	if h < 0:
		dy1 = -1
	elif h > 0:
		dy1 = 1
		
	var longest = absW
	var shortest = absH
	
	if longest <= shortest:
		longest = absH
		shortest = absW
		if h < 0:
			dy2 = -1
		elif h > 0:
			dy2 = 1
			
		dx2 = 0
	
	var numerator = longest >> 1

	
	for i in range(1,longest):
		numerator += shortest
		if numerator >= longest:
			numerator -= longest
			x += dx1
			y += dy1
		else:
			x += dx2
			y += dy2
		
		if (!walkable[x][y]):
			path.append(start)
			return path
		path.append(Vector2(x,y))
	return path
			
							
		
	
	
	
	
	
	
	

