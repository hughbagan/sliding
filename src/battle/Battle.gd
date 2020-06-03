extends Node2D

onready var center :Vector2 = $Center.get_position()
onready var party := [$Center/Sprite, $Center/Sprite2, $Center/Sprite3]
var oval_radii := Vector2(200.0, 30.0)
onready var party_min := Vector2(center.x - oval_radii.x, center.y - oval_radii.y)
onready var party_max := Vector2(center.x + oval_radii.x, center.y + oval_radii.y)

var x = 0.0 # sin(x)

func _ready():
	party[0].set_position(party_min)

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		x -= 0.02
	elif Input.is_action_pressed("ui_right"):
		x += 0.02
	#print("sin(x) = ", sin(x))
	print(cos(x+PI)+1)
	var pos_x : float = party_min.x + ((cos(x+PI)+1) * 200.0)
	party[0].set_position(Vector2(pos_x, party_min.y))
