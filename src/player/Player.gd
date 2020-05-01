class_name Player extends KinematicBody2D
# Class Description
# Push timer: https://www.reddit.com/r/godot/comments/8p3lm0/fps_counter_in_game/


export var move_speed := 125.0
var motion := Vector2()

var direction :int = Global.Direction.DOWN
const PUSH_SPEED := 0.2 	# for a Tween
const PUSH_BUFFER := 0.35 	# in seconds
var push_timer := 0.0
var throwing := false
var throwing_object : GridBox
var throw_cast_length : float = min(OS.get_window_size().x, OS.get_window_size().y)*0.5
var throw_direction :int # passed to throwing_object


func _physics_process(delta: float) -> void:
	# Throw boxes from afar
	if Input.is_action_just_pressed("space"):
		# Activate the casting
		if not $ThrowRayCast.enabled:
			$ThrowRayCast.set_enabled(true)
			raycast(direction)
	if $ThrowRayCast.enabled:
		# Choose a direction to throw in
		if Input.is_action_just_pressed("player_right"):
			throw_direction = Global.Direction.RIGHT
		elif Input.is_action_just_pressed("player_left"):
			throw_direction = Global.Direction.LEFT
		elif Input.is_action_just_pressed("player_down"):
			throw_direction = Global.Direction.DOWN
		elif Input.is_action_just_pressed("player_up"):
			throw_direction = Global.Direction.UP
		else:
			return # Don't allow movement while throwing (necessary?)
		if throwing_object is GridBox:
			throwing_object.throw(throw_direction)
		$ThrowRayCast.set_enabled(false)
	
	# Movement
	motion.x = int(Input.get_action_strength("player_right")) - int(Input.get_action_strength("player_left"))
	motion.y = int(Input.get_action_strength("player_down")) - int(Input.get_action_strength("player_up"))
	move_and_slide(motion.normalized() * move_speed, Vector2())
	if get_slide_count() > 0:
		if get_slide_collision(0).collider is GridBox:
			check_box_collision(delta, motion)
	else:
		push_timer = 0.0
	# Set direction based on movement
	if Input.is_action_just_pressed("player_right"):
		direction = Global.Direction.RIGHT
	elif Input.is_action_just_pressed("player_left"):
		direction = Global.Direction.LEFT
	elif Input.is_action_just_pressed("player_down"):
		direction = Global.Direction.DOWN
	elif Input.is_action_just_pressed("player_up"):
		direction = Global.Direction.UP


func check_box_collision(delta:float, caller_motion: Vector2) -> void:
	if abs(caller_motion.x) + abs(caller_motion.y) > 1:
		# Ensures we can't push diagonally
		return
	var box := get_slide_collision(0).collider as GridBox
	if box:
		push_timer += delta
		if push_timer > PUSH_BUFFER:
			box.push(caller_motion, PUSH_SPEED)
	else:
		push_timer = 0.0


func raycast(cast_direction:int) -> void:
	var space_state := get_world_2d().direct_space_state
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
	if $ThrowRayCast.get_collider() is GridBox:
		throwing_object = $ThrowRayCast.get_collider()



