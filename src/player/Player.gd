class_name Player extends KinematicBody2D


export var move_speed := 125.0
var motion := Vector2()
# Push timer: https://www.reddit.com/r/godot/comments/8p3lm0/fps_counter_in_game/
const PUSH_SPEED := 0.2
const THROW_SPEED := 0.1
const PUSH_BUFFER := 0.35
var push_timer := 0.0
var casting := false
var casting_object : GridBox


func _ready() -> void:
	#print("Player anim texture: %dx%d" % [spr_w, spr_h])
	pass


func _physics_process(delta: float) -> void:
	# Casting
	if Input.is_action_just_pressed("space"):
		if not casting:
			raycast()
		else:
			throw()
	if casting:
		return
	
	# Movement
	motion.x = int(Input.get_action_strength("player_right")) - int(Input.get_action_strength("player_left"))
	motion.y = int(Input.get_action_strength("player_down")) - int(Input.get_action_strength("player_up"))
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
			box.push(caller_motion, PUSH_SPEED)
	else:
		push_timer = 0.0


func raycast() -> void:
	var space_state := get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var ray_to := Vector2(OS.get_window_size().x, self.get_global_position().y)
	var result := space_state.intersect_ray(self.get_global_position(), ray_to, [self])
	print(result)
	if result.collider is GridBox:
		casting = true
		casting_object = result.collider


func throw() -> void:
	# "Throw" the casted object
	var casted_motion = Vector2(1.0, 0.0)
	casting_object.throw(casted_motion, THROW_SPEED)
	casting = false


#func _draw():
#	draw_line(self.get_global_position(), \
#			Vector2(OS.get_window_size().x, self.get_global_position().y), Color.red, 5.0)



