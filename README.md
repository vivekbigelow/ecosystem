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

**ready() : void**
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

**RegisterDeath(entity) : void**
prints the name of the entity and frees the entity from the queue

**get_next_tile_random(current : Vector2) : Vector2**



  
 
