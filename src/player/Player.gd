class_name Player extends KinematicBody2D


export var move_speed : = 250.0
var motion := Vector2()
# Push timer: https://www.reddit.com/r/godot/comments/8p3lm0/fps_counter_in_game/
const PUSH_TIME := 0.35
var push_timer := 0.0


func _ready() -> void:
	#print("Player anim texture: %dx%d" % [spr_w, spr_h])
	pass


func _physics_process(delta: float) -> void:
	motion.x = int(Input.get_action_strength("player_right")) - int(Input.get_action_strength("player_left"))
	motion.y = int(Input.get_action_strength("player_down")) - int(Input.get_action_strength("player_up"))
	move_and_slide(motion.normalized() * move_speed, Vector2())
