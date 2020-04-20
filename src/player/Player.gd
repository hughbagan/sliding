class_name Player extends KinematicBody2D
# Class Description
# Push timer: https://www.reddit.com/r/godot/comments/8p3lm0/fps_counter_in_game/


export var move_speed := 125.0
var motion := Vector2()
enum Direction {UP, DOWN, LEFT, RIGHT}
var direction = Direction.DOWN
const PUSH_SPEED := 0.2 	# for a Tween
const PUSH_BUFFER := 0.35 	# in seconds
var push_timer := 0.0
var throwing := false
var throwing_object : GridBox
var throw_cast_length : float = min(OS.get_window_size().x, OS.get_window_size().y)*0.5


func _ready() -> void:
	#print("Player anim texture: %dx%d" % [spr_w, spr_h])
	pass


func _physics_process(delta: float) -> void:
	# Throw boxes from afar
	if Input.is_action_just_pressed("space"):
		if not $ThrowRayCast.enabled:
			$ThrowRayCast.set_enabled(true)
			raycast(direction)
		else:
			throw()
			$ThrowRayCast.set_enabled(false)
	if $ThrowRayCast.enabled:
		return # Don't allow movement while casting
	
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
		direction = Direction.RIGHT
	elif Input.is_action_just_pressed("player_left"):
		direction = Direction.LEFT
	elif Input.is_action_just_pressed("player_down"):
		direction = Direction.DOWN
	elif Input.is_action_just_pressed("player_up"):
		direction = Direction.UP


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
	if cast_direction == Direction.RIGHT:
		ray_to = Vector2(OS.get_window_size().x, get_global_position().y)
	elif cast_direction == Direction.LEFT:
		ray_to = Vector2(0, get_global_position().y)
	elif cast_direction == Direction.UP:
		ray_to = Vector2(get_global_position().x, 0)
	elif cast_direction == Direction.DOWN:
		ray_to = Vector2(get_global_position().x, OS.get_window_size().y)
	$ThrowRayCast.set_cast_to(ray_to)
	$ThrowRayCast.force_raycast_update()
	var collider = $ThrowRayCast.
	var result := space_state.intersect_ray(get_global_position(), ray_to, [self])
	print(result)
	if result.collider is GridBox:
		throwing_object = result.collider


func throw() -> void:
	#var throw_direction = Vector2(1.0, 0.0)
	throwing_object.throw()


