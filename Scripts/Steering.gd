extends Node

const DEFAULT_MASS: = 2.0
const DEFAULT_MAX_SPEED: = 7.0
const DEFAULT_SLOW_RADIUS = 10.0
const DEFAULT_PANIC_DISTANCE = 100.0
const DEFAULT_WANDER_RADIUS = 500.0
const DEFAULT_WANDER_DISTANCE = 5.0
const DEFAULT_JITTER = 100.0


static func seek (
		velocity: Vector3,
		global_position: Vector3,
		target_position: Vector3,
		max_speed:= DEFAULT_MAX_SPEED,
		mass:= DEFAULT_MASS
) -> Vector3 :
	var desired_velocity: = (target_position - global_position).normalized() * max_speed
	var steering := (desired_velocity - velocity) / mass
	return steering + velocity


	
static func arrive (
	velocity: Vector3,
	global_position: Vector3,
	target_position: Vector3,
	max_speed:= DEFAULT_MAX_SPEED,
	slow_radius:= DEFAULT_SLOW_RADIUS,
	mass: = DEFAULT_MASS
) -> Vector3:
	
	var to_target: = global_position.distance_to(target_position)
	var desired_velocity: = (target_position - global_position).normalized() * max_speed
	if to_target < slow_radius:
		desired_velocity *= (to_target/slow_radius) * 0.8 + 0.2
	
	var steering := (desired_velocity - velocity) / mass

	return velocity + steering
	
static func flee (
	velocity: Vector3,
	global_position: Vector3,
	target_position: Vector3,
	max_speed:= DEFAULT_MAX_SPEED,
	panic_distance:= DEFAULT_PANIC_DISTANCE,
	mass: = DEFAULT_MASS
) -> Vector3:
	if (global_position.distance_squared_to(target_position) > (panic_distance * panic_distance)):
		return Vector3.ZERO
	else:
		var desired_velocity := (global_position - target_position).normalized() * max_speed
		var steering := (desired_velocity - velocity)/mass
		
		return steering + velocity
		
static func wander (
	global_position: Vector3,
	wander_radius:=DEFAULT_WANDER_RADIUS,
	wander_distance:= DEFAULT_WANDER_DISTANCE,
	jitter := DEFAULT_JITTER ) -> Vector3:
		
	var theta = (rand_range(0,20) * 2 * PI)
	var wander_target = Vector3(wander_radius* cos(theta), 0, wander_radius * sin(theta))
	wander_target += Vector3(rand_range(-1,1) * jitter, 0, rand_range(-1,1) * jitter)
	wander_target = wander_target.normalized()
	wander_target *= wander_radius
	
	var target_local = wander_target + Vector3(wander_distance, 0, wander_distance)
	
	return (global_position - target_local) * Vector3(1,0,1)

	
	

