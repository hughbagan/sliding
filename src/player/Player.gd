class_name Player extends KinematicBody2D


export var move_speed : = 125.0
var motion := Vector2()
# Push timer: https://www.reddit.com/r/godot/comments/8p3lm0/fps_counter_in_game/
export var push_speed : = 125.0
const PUSH_TIME := 0.35
var push_timer := 0.0


func _ready() -> void:
	#print("Player anim texture: %dx%d" % [spr_w, spr_h])
	pass


func _physics_process(delta: float) -> void:
	motion.x = int(Input.get_action_strength("player_right")) - int(Input.get_action_strength("player_left"))
	motion.y = int(Input.get_action_strength("player_down")) - int(Input.get_action_strength("player_up"))
	move_and_slide(motion.normalized() * move_speed, Vector2())
	if get_slide_count() > 0:
		if get_slide_collision(0).collider is GridBox:
			check_box_collision(delta, motion)
	else:
		push_timer = 0.0


func check_box_collision(delta:float, motion: Vector2) -> void:
	if abs(motion.x) + abs(motion.y) > 1:
		# Ensures we can't push diagonally
		return
	var box : = get_slide_collision(0).collider as GridBox
	if box:
		push_timer += delta
		if push_timer > PUSH_TIME:
			box.push(push_speed * motion)
	else:
		push_timer = 0.0


