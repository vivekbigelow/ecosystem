extends Spatial

var GameWorldScene = preload("res://Scenes/GameWorld.tscn")

func _ready():
	var gameWorld = GameWorldScene.instance()
	gameWorld.init(50)
	self.add_child(gameWorld)
