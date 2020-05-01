extends KinematicBody

class_name Animal

#Settings
var GameWorld 
var maxViewDistance 
var timeToDeathByHunger = 200
var timeToDeathByThirst = 200
var timeToDeathByAge = 400
#var timebetweenActionChoices = 1

var position := Vector2.ZERO
#onready var terrain = self.get_node("../Terrain")
var speed = 1.5
var velocity := Vector3.ZERO

var hunger : float
var thirst : float
var age 
var criticalPercent  = 0.7

var foodTarget
var waterTarget

var dead : bool

enum CauseOfDeath{
	Hunger,
	Thirst,
	Age,
	Eaten
}

enum CreatureAction{
	None,
	Resting,
	Exploring,
	GoingToFood,
	GoingToWater,
	Eating,
	Drinking,
	SearchingForMate
}

var currentAction = CreatureAction.Exploring #Creature Action

#Movement
var animatingMovement : bool
var moveTargetPosition : Vector2
var moveTime = 0.0
var moveSpeedFactor = 1.0
var moveArcHeight = 0.2
var moveArcHeightFactor = 1.0
var path = []
var pathIndex : int



func _ready():
	pass
	
func init(position : Vector2, gameworld):
	GameWorld = gameworld
	maxViewDistance = GameWorld.maxViewDistance
	self.position = position
	self.translation = Vector3(position.x , 1, position.y)
	age = 0
	hunger = 0
	age = 0
	print("Exploring")
	#moveFromPosition = position
	ChooseNextAction()
	
func _process(delta)->void:
	hunger += delta * 10 / timeToDeathByHunger
	thirst += delta * 10 / timeToDeathByThirst
	age+= delta * 10/timeToDeathByAge
	
	if (hunger >= 1.5):
		Die(CauseOfDeath.Hunger)
	if(thirst >= 1):
		Die(CauseOfDeath.Thirst)
	if(age >= 1):
		Die(CauseOfDeath.Age)
		
	if(animatingMovement):	
		AnimateMove(delta)
	else:
		ChooseNextAction()
	

func ChooseNextAction():
	#var currentlyEating = currentAction == CreatureAction.Eating and foodTarget and hunger > 0

	if ((thirst >= criticalPercent) and (currentAction != CreatureAction.GoingToWater and currentAction != CreatureAction.Drinking)):
		FindWater()
	if ((hunger >= thirst) and (thirst < criticalPercent) and (hunger >= criticalPercent) and (currentAction != CreatureAction.GoingToFood and currentAction != CreatureAction.Eating)):
		FindFood()
	
	Act()
	
func Act()->void:
	
	if currentAction == CreatureAction.Exploring:
		print("Exploring")
		StartMoveToPosition(GameWorld.get_next_tile_random(position))
		
	elif currentAction == CreatureAction.GoingToFood:
	
		if(position.x == foodTarget.x and position.y == foodTarget.y):
			#LookAt(foodTarget.position)
			currentAction = CreatureAction.Eating
			print("Eating")
		else:
			StartMoveToPosition (foodTarget)
			pathIndex = 0
		
	elif currentAction == CreatureAction.GoingToWater:
		if (position.x == waterTarget.x and position.y == waterTarget.y):
			#LookAt(waterTarget)
			currentAction = CreatureAction.Drinking
			print("Drinking")
		
		else:
			print("GoingToWater")
			StartMoveToPosition(waterTarget)
			pathIndex = 0
			
	elif currentAction == CreatureAction.Drinking:
		DrinkWater()
	elif currentAction == CreatureAction.Eating:
		EatFood()
		
			
		
	
func StartMoveToPosition (target : Vector2):
	
	moveTargetPosition = target
	
	animatingMovement = true
	

func FindFood():
	var foodTile = GameWorld.SenseFood(position)
	if(foodTile):
		currentAction = CreatureAction.GoingToFood
		print("Going To Food")
		foodTarget = foodTile
		StartMoveToPosition(foodTarget)
	else:
		currentAction = CreatureAction.Exploring
	
func FindWater():
	var shoreTile = GameWorld.SenseWater(position)
	if(shoreTile):
		currentAction = CreatureAction.GoingToWater
		print("GoingToWater")
		waterTarget = shoreTile
		StartMoveToPosition(waterTarget)
	else:
		currentAction =  CreatureAction.Exploring

func DrinkWater():
	thirst = 0
	currentAction = CreatureAction.Exploring
	print("Exploring")
	ChooseNextAction()

func EatFood():
	hunger = 0
	currentAction = CreatureAction.Exploring
	print("Exploring")
	ChooseNextAction()
	
func CreatePath (target : Vector2):
	if (path == null or pathIndex >= path.size() or path[0] != target or path[pathIndex] != moveTargetPosition):
		path = GameWorld.GetPath(position, target)
		pathIndex = 0

func AnimateMove(delta):
	var start = Vector3(position.x, 1, position.y)
	var target = Vector3 (moveTargetPosition.x, 1, moveTargetPosition.y)
	moveTime = min(1, moveTime + delta * speed)
	self.translation.y = sin(PI * moveTime) + 0.5
	self.translation.x = lerp(start.x, target.x, moveTime)
	self.translation.z = lerp(start.z, target.z, moveTime)
	if moveTime >= 1:
		self.position = Vector2(target.x, target.z)
		#self.translation = Vector3(position.x, 1, position.y)
		animatingMovement = false
		moveTime = 0
		ChooseNextAction()
	
func Die(cause)->void:
	if (!dead):
		dead = true
		if cause == 0:
			print("Died from Hunger")
		elif cause == 1:
			print("Died from Thirst")
		elif cause == 2:
			print("Died from Age")
		elif cause == 3:
			print("Was Eaten")
		
		GameWorld.RegisterDeath(self)
		#Free from queue






	
	



