extends Node2D

onready var center :Vector2 = $Center.get_position()
onready var party := [$YSort/Sprite, $YSort/Sprite2, $YSort/Sprite3]
var oval_radii := Vector2(250.0, 20.0)
onready var party_min := Vector2(center.x - oval_radii.x, center.y - oval_radii.y)
onready var party_max := Vector2(center.x + oval_radii.x, center.y + oval_radii.y)

var char_x = []
#var x = 0.0 # sin(x)

func _ready():
	party[0].set_position(party_min)
	for i in range(party.size()):
		var start_x = 0.0 + (i*0.2)
		char_x.append(start_x)
	print(char_x)

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		for i in range(char_x.size()):
			char_x[i] -= 0.01
	elif Input.is_action_pressed("ui_right"):
		for i in range(char_x.size()):
			char_x[i] += 0.01
	print(char_x)
	#print("sin(x) = ", sin(x))
	#print(cos(x+PI)+1)
	for i in range(party.size()):
		var pos_x : float = party_min.x + (( cos(PI*char_x[i] + PI) +1) * oval_radii.x)
		var pos_y : float = party_min.y + ((sin(PI*char_x[i])) * oval_radii.y)
		#var pos_y : float = party_min.y + ((cos(2*x+PI)+1) * oval_radii.y)
		party[i].set_position(Vector2(pos_x, pos_y))
	
	
