# ecosystem

My goal was to create a simulated ecosystem with reproducing agents that pass genes along to later generations. The initial goal was to include three species. A plant that is the food source for an herbivore, a herbivore that is the food source for a carnivore, and a carnivore. 

The simulation in itself is not a game. One solution to make the experience more engaging for the player would be to have the player control a ranger on a wildlife park whose job it is to make sure the ecosystem is balanced and ensure that no species goes extinct.

ecosystem is built in the godot game engine


## Scenes 

### SceneRoot
#### Scripts : SceneRoot.gd
#### SceneTree : SceneRoot Spatial, KinematicBody Body , DirectionalLight

SceneRoot is the main scene of the game and creates instances of the other scenes in the game. SceneRoot.gd initializes the GameWorld Scene which generates the other components of the game. 

### GameWorld
#### Scripts : GameWorld.gd
#### SceneTree : GameWorld Spatial

GameWorld is the main gameobject that contains the useful data for the child nodes. GameWorld's main purpose is to generate the terrain and spawn the game agents. By making a single class create all of the other objects in the game it allows the GameWorld to act as a bridge between different objects. The design of GameWorld is flawed because it acts as a god class, a better implementation would modularize the different aspects of the class.

### Terrain
#### Scripts : Terrain.gd
#### SceneTree : Terrain Spatial

An empty Spatial that generates the terrain using the Terrain.gd script. An instance of the Terrain Scene is instantiated by the GameWorld Scene to generate all of the terrain tiles and create useful 2d Arrays of data on tiles for the other game agents.

### Body
#### Scripts : Body.gd
#### SceneTree : KinematicBody body, MeshInstance bodyMesh, CollisionShape bodyCollisionShape, Camera head

The Body scene acts as an First Person Controller for the player. The player is able to walk on any tile (although it collides with plants and trees)


### GrassTile
#### Scripts : GrassTile.gd
#### SceneTree : Spatial GrassTile , StaticBody cube, MeshInstance tile, CollisionShape tileCollisionShape

The GrassTile scene houses a staticbody cube. Of the 4 tiles in the game this is the only one that agents can walk on. The main spatial is actually not needed.

### WaterTile
#### Scripts : WaterTile.gd
#### SceneTree : Spatial WaterTile, StaticBody cube, MeshInstance tile, CollisionShape

The WaterTile is represents water in the terrain. Agents can not walk on water tiles

### TreeTile
#### Scripts : TreeTile.gd
#### SceneTree : Spatial TreeTile, Tree Scene, StaticBody cube

The TreeTile is used to spawn trees in the terrain. 

### PlantTile
#### Scripts : PlantTile.gd
#### SceneTree : Spatial PlantTile, Plant Scene, StaticBody cube

The PlantTile contains the plant scene and model and is used as the basis for plant tiles in the terrain generator.

### Tree
#### SceneTree : StaicBody Tree, treeMesh, treeCollisionShape

An inherited scene from the tree.glb model. Used as a node in the TreeTile scene. 

### Plant
#### SceneTree : StaticBody Plant

An inherited scene from the plant.glb model. Used as a node in the PlantTile scene.


## Scripts

### SceneRoot.gd

Extends : Spatial

#### Member Variables

GameWorld Scene : a preload of the GameWorld scene

#### Methods

*ready() : void*

creates an instance of the GameWorld Scene and calls the GameWorld init function passing a size of 50. Adds the GameWorld instance to the scene tree.

### GameWorld.gd

Extends : Spatial

#### Member Variables

TerrainScene : a preload of the Terrain Scene

terrainGenerator : a Terrain object made for calling methods from the Terrain class

AnimalScene : a preload of the Animal Scene

size : the size of the map (currently the map only makes a square with width and height equal to size)

walkable : a 2d Array of booleans where the indicies relate to tile positions. If the element is true then agents can walk on the tile at that position

walkAbleNeighborsMatrix : a 2d Array of Vector2 objects where indicies relate to the position of tiles in the map. Each tile position contains an array of the positions of tiles that are walkable and neighbor the tile at the index position. 

walkableTiles : an array containing all of the walkable tiles in the map

isShore : a 2d Array of booleans. Each element corresponds to a tile in the map and is true if that tile is walkable and neighbors a water tilei

isFood : a 2d Array of booleans. Each element corresponds to a tile in the map and is true if that tile is a plant tile. (Since I only have rabbits, the only food is plants)

isFoodNeighbor : a 2d Array of booleans. Elements are true if the tile neighbors a plant tile and is walkable.

shoreTiles : an array of the positions of all the walkable tiles that neighbor water tiles

foodTiles : an array of the positions of all the plant tiles

closestVisibleShoreMatrix : a 2d Array of Vector2 positions. Each Vector2 corresponds to a tile on the map and contains the position of the closest Shore tile that is within the maxViewDistance. The current implementation does not utilize this array. The idea is that when an animal needs to build a path to a shore tile for water this array will return the closest shore tile that they can see. 

maxViewDistance : the maximum distance that an animal can see.

#### Methods

*init(size : int) : void*

creates an instance of the terrain scene with width and height of size and adds it to the scene tree. Assigns and creates the useful tile data arrays. Spawns the initial population.

*RegisterDeath(entity) : void*

prints the name of the entity and frees the entity from the queue

*get_next_tile_random(current : Vector2) : Vector2*

takes a Vector2 position **current** and returns a position of a walkable neighbor tile to that position. If there aren't any walkable neighbors then the original position is returned. If there are multiple neighbors than a random one is selected. This method is used for the Exploring state of animals.

*SenseWater(position : Vector2) : Vector2*

takes a Vector2 position and returns the position of a random shore tile (a tile that is walkable and neighbors water)

*SenseFood (position : Vector2) : Vector2*

takes a Vector2 position and returns the position of a random plant tile

*spawnInitialPopulation() : void*
creates between 1 and 10 animal instances and gives each an inital position on a random walkable tile

#### Utility Methods

Mehtods in the GameWorld class that help other functions.

*CheckNeighbors(position : Vector2, target : Vector2) : bool*

Checks if the two positions are neighbors and returns a boolean

*Vector2Compare(a : Vector2, b : Vector2) : bool*

compares the squared magnitude of two Vectors and returns true if a < b and false if a > b

*GetPath(start : Vector2, end : Vector2) : Array of Vector2s that form a path from start to end, where each Vector 2 contains the position of a walkable tile*

Currently this method just appends the end position to an array and returns it. So when an animal creates a path it will jump straight to the end position. I originally used the bresenham line algorithm to get a straight path from start to end, but those paths will almost never be completly walkable. A better approach would be using A star or another path finding algorithm to generate a path to the target. 

### Terrain.gd

Extends : Spatial

#### Member Variables

noise : instance of the OpenSimplexNoise class. Used for generating noise values

grassTiles : Array containing all grass tiles

waterTiles : Array containing all water tiles

plantTiles : Array containing all plant tiles

treeTiles : Array containing all tree tiles

walkable : 2d Array of booleans, where each element corresponds to a tile in the terrain. If the tile is grass than the element is true

walkableTiles : Array of the positions of grass tiles. I found that I needed the positions of the tiles more than the acutal tile instance. 

isWater : 2d Array of booleans, where each element corresponds to a tile in the terrain. If the tile is water than the element is true.

walkableNeighborsMatrix : 2d Array of arrays of Vector2 positions, where each Vector2 array contains the walkable neighbors of each tile in the map.

isShore : a 2d Array of booleans. Each element corresponds to a tile in the map and is true if that tile is walkable and neighbors a water tilei

isFood : a 2d Array of booleans. Each element corresponds to a tile in the map and is true if that tile is a plant tile. (Since I only have rabbits, the only food is plants)

isFoodNeighbor : a 2d Array of booleans. Elements are true if the tile neighbors a plant tile and is walkable.
 
size : the size of the map, used to create a square with width and height equal to size

GrassTileScene : preload of GrassTileScene

WaterTileScene : preload of WaterTileScene

TreeTileScene : preload of TreeTileScene

PlantTileScene : preload of PlantTileScene

#### Methods

*init(size) : void*

calls the randomize() to reset the seed. Assigns and creates the tile data arrays. Generates the terrain.

*test_generate(width,height) : void*

creates a map of all grass tiles for testing purposes

*generate_terrain(width, height) : void*

sets the parameters of the noise. Creates the tiles of the terrain based on values obtained by from noise.get_noise_2d(x,z), where x and z are the coordinates of the new tile. Noise is just used for creating water and grass tiles, so that the terrain looks natural. If a grasstile is going to be made a random number is used to determine if the new tile will be a tree or a plant. 

*generate_tile(type : int, position : Vector3) : void*

Called by generate_terrain() to create individual tiles. The type indicates which kind of tile is made and the position is the position of the tile. Adds each tile to the Scene Tree. 

*find_walkable_neighbors() : void*

creates the walkable neighbors matrix

*walkable_tiles() : void*

creates the walkable matrix of boolean values

*find_shore_tiles() : void*
 
creates the isShore matrix

*find_food_neighbor_tiles() : void*

creates the isFoodNeighbor matrix

### Tile.gd

Extends : Spatial

#### Member Variables

tiletype : The type of tile

position : The Vector3 position of the tile

#### Methods

*init(positionVector: Vector3(0,0,0)) : void*

sets position to passed positionVector. Translates the scene to position. 

*get_tile_type() : String*

returns the type of the tile



  
 
