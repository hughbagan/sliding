extends Node2D

onready var center :Vector2 = $Center.get_position()
var oval_radius := Vector2(270.0, 15.0) # the ellipse that the actors move along
onready var actors := [$YSort/Char1, $YSort/Char2, $YSort/Char3, $YSort/Enemy]
onready var actors_min := Vector2(center.x - oval_radius.x, center.y - oval_radius.y)
onready var actors_max := Vector2(center.x + oval_radius.x, center.y + oval_radius.y)

var offset := 0.1

var tween_x := []
var tweening := false


func _ready():
	# Initialize
	actors[0].set_position(actors_min)
	for i in range(actors.size()):
		actors[i].x = 0.6 + (i*offset)
		if actors[i].get_name() == "Enemy":
			actors[i].x = 1.7
		tween_x.append(0.0)


func _physics_process(delta):
	# Get input, which affects x
	if Input.is_action_pressed("ui_left"):
		for i in range(actors.size()):
			actors[i].x -= 0.01
		print(actors[3].x)
	elif Input.is_action_pressed("ui_right"):
		for i in range(actors.size()):
			actors[i].x += 0.01
		print(actors[3].x)
	elif Input.is_action_just_pressed("1"):
		_actors_set_position(1, true)
	elif Input.is_action_just_pressed("2"):
		_actors_set_position(2, true)
	
	# Run the x vars through the trig expressions to get positions
	for i in range(actors.size()):
		actors[i].set_position(oval_position(oval_fraction_x(actors[i].x), oval_fraction_y(actors[i].x)))


func oval_fraction_x(x:float) -> float:
	"""
	Calculates a decimal that represents a fraction of the 
	oval's radius width (x).
	"""
	return cos(PI*x + PI) + 1


func oval_fraction_y(x:float) -> float:
	"""
	Calculates a decimal that represents a fraction of the 
	oval's radius height (y).
	"""
	return sin(PI*x)


func oval_position(x:float, y:float) -> Vector2:
	"""
	Calculates a position based on output from oval_fraction (ie. a fraction 
	of the oval's height and width)
	"""
	var pos_x : float = actors_min.x + x * oval_radius.x
	var pos_y : float = actors_min.y + y * oval_radius.y
	return Vector2(pos_x, pos_y)


func _actors_set_position(pos:int, tween:bool=false):
	if pos == 1:
		if tween:
			for i in range(actors.size()):
				tween_x[i] = 0.6 + (i*offset)
				if actors[i].get_name() == "Enemy":
					tween_x[i] = 1.7
				$BattleTween.interpolate_property(actors[i], "x", actors[i].x, tween_x[i], 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
			$BattleTween.start()
			tweening = true
		else:
			# Just set their position immediately
			for i in range(actors.size()):
				actors[i].x = 0.6 + (i*offset)
				if actors[i].get_name() == "Enemy":
					actors[i].x = 1.7
	elif pos == 2:
		if tween:
			for i in range(actors.size()):
				if actors[i].get_name() == "Enemy":
					tween_x[i] = 0.3
					$BattleTween.interpolate_property(actors[i], "x", actors[i].x, tween_x[i], 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
				else:
					tween_x[i] = 1.4 - (i*offset)
					$BattleTween.interpolate_property(actors[i], "x", actors[i].x, tween_x[i], 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
			$BattleTween.start()
			tweening = true
		else:
			# Just set their position immediately
			for i in range(actors.size()):
				actors[i].x = 1.4 - (i*offset)
				if actors[i].get_name() == "Enemy":
					actors[i].x = 0.3


func _on_BattleTween_tween_all_completed():
	tweening = false
	print("Done tweening!")
