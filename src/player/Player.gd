class_name Player extends KinematicBody2D
# Class Description
# Push timer: https://www.reddit.com/r/godot/comments/8p3lm0/fps_counter_in_game/


export var move_speed := 125.0
var motion := Vector2()

var looking_direction :int = Global.Direction.DOWN

const SLIDING_TIME := 0.23 	# for a Tween
const PUSH_BUFFER := 0.25 	# in seconds
var push_timer := 0.0

var throwing := false
var throwing_object
var throw_cast_length : float = min(OS.get_window_size().x, OS.get_window_size().y)*0.5
var throw_direction :int = Global.Direction.NONE # passed to throwing_object


func _ready():
	Global.PlayerNode = self


func _physics_process(delta: float) -> void:
	# Looking and then Throwing
	if not throwing:
		if Input.is_action_just_pressed("player_look_right"):
			looking_direction = Global.Direction.RIGHT
		elif Input.is_action_just_pressed("player_look_left"):
			looking_direction = Global.Direction.LEFT
		elif Input.is_action_just_pressed("player_look_down"):
			looking_direction = Global.Direction.DOWN
		elif Input.is_action_just_pressed("player_look_up"):
			looking_direction = Global.Direction.UP
		else:
			looking_direction = Global.Direction.NONE
		if looking_direction != Global.Direction.NONE:
			throwing_object = raycast(looking_direction)
			if throwing_object is GridBox:
				$ThrowRayCast.enabled = true
				throwing = true
	else: # We've already raycast, now "throw" the object
		# Choose a throw_direction
		if Input.is_action_just_pressed("player_look_right"):
			throw_direction = Global.Direction.RIGHT
		elif Input.is_action_just_pressed("player_look_left"):
			throw_direction = Global.Direction.LEFT
		elif Input.is_action_just_pressed("player_look_down"):
			throw_direction = Global.Direction.DOWN
		elif Input.is_action_just_pressed("player_look_up"):
			throw_direction = Global.Direction.UP
		#else:
		#	return # Disables movement while throwing
		if throwing_object is GridBox and throw_direction != Global.Direction.NONE:
			throwing_object.throw(throw_direction)
			$ThrowRayCast.enabled = false
			throwing = false
			throw_direction = Global.Direction.NONE
	
	# Movement
	motion.x = int(Input.get_action_strength("player_move_right")) - int(Input.get_action_strength("player_move_left"))
	motion.y = int(Input.get_action_strength("player_move_down")) - int(Input.get_action_strength("player_move_up"))
	#print(motion)
	move_and_slide(motion.normalized() * move_speed, Vector2())
	if get_slide_count() > 0:
		if get_slide_collision(0).collider is GridBox:
			check_box_collision(delta, motion)
	else:
		push_timer = 0.0


func check_box_collision(delta:float, caller_motion: Vector2) -> void:
	if abs(caller_motion.x) + abs(caller_motion.y) > 1:
		# Ensures we can't push diagonally
		return
	var box := get_slide_collision(0).collider as GridBox
	if box:
		push_timer += delta
		if push_timer > PUSH_BUFFER:
			box.push(caller_motion, SLIDING_TIME)
	else:
		push_timer = 0.0


func raycast(cast_direction:int) -> Object:
	# use global coordinates, not local to node
	var ray_to : Vector2
	if cast_direction == Global.Direction.RIGHT:
		ray_to = Vector2(throw_cast_length, 0)
	elif cast_direction == Global.Direction.LEFT:
		ray_to = Vector2(-throw_cast_length, 0)
	elif cast_direction == Global.Direction.UP:
		ray_to = Vector2(0, -throw_cast_length)
	elif cast_direction == Global.Direction.DOWN:
		ray_to = Vector2(0, throw_cast_length)
	$ThrowRayCast.set_cast_to(ray_to)
	$ThrowRayCast.force_raycast_update()
	print("SELECT: ", $ThrowRayCast.get_collider())
	return $ThrowRayCast.get_collider()

