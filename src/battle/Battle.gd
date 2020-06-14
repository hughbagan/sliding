extends Node2D

onready var center :Vector2 = $Center.get_position()
onready var actors := [$YSort/Char1, $YSort/Char2, $YSort/Char3, $YSort/Enemy]
var oval_radii := Vector2(270.0, 15.0) # the ellipse that the actors to move along
onready var actors_min := Vector2(center.x - oval_radii.x, center.y - oval_radii.y)
onready var actors_max := Vector2(center.x + oval_radii.x, center.y + oval_radii.y)
var actors_x := [] # cos(actors_x[i])
var offset := 0.1
var tweening := false
var tween_x := []


func _ready():
	# Initialize
	actors[0].set_position(actors_min)
	for i in range(actors.size()):
		var start_x = 0.6 + (i*offset)
		if actors[i].get_name() == "Enemy":
			start_x = 1.7
		actors_x.append(start_x)
		tween_x.append(0.0)
	print(actors_x)
	#$BattleTween.set_tween_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#$BattleTween.set_tween_property(self)


func _physics_process(delta):
	if tweening:
		for i in range(actors.size()):
			var pos_x : float = actors_min.x + (( cos(PI*actors_x[i] + PI) +1) * oval_radii.x)
			var pos_y : float = actors_min.y + ((sin(PI*actors_x[i])) * oval_radii.y)
			#var pos_y : float = actors_min.y + ((cos(2*x+PI)+1) * oval_radii.y)
			actors[i].set_position(Vector2(pos_x, pos_y))
	
	else:
		# Get input, which affects x
		if Input.is_action_pressed("ui_left"):
			for i in range(actors_x.size()):
				actors_x[i] -= 0.01
			print(actors_x)
		elif Input.is_action_pressed("ui_right"):
			for i in range(actors_x.size()):
				actors_x[i] += 0.01
			print(actors_x)
		elif Input.is_action_just_pressed("1"):
			_actors_set_position(1)
		elif Input.is_action_just_pressed("2"):
			_actors_set_position(2, true)
		
		# Run x through the trig expressions to get positions
		for i in range(actors.size()):
			var pos_x : float = actors_min.x + (( cos(PI*actors_x[i] + PI) +1) * oval_radii.x)
			var pos_y : float = actors_min.y + ((sin(PI*actors_x[i])) * oval_radii.y)
			#var pos_y : float = actors_min.y + ((cos(2*x+PI)+1) * oval_radii.y)
			actors[i].set_position(Vector2(pos_x, pos_y))


func oval_fraction(x_coord:float) -> Vector2:
	"""
	Calculates two decimals that represents a fraction of the oval's size.
	The return value is multiplied by the oval's size to get a position.
	"""
	# TODO move lines 53-54 here, and put pos_x, pos_y into a Vector and return.
	return Vector2(0,0)


func _actors_set_position(pos:int, tween:bool=false):
	if pos == 1:
		if tween:
			for i in range(actors.size()):
				tween_x[i] = 0.6 + (i*offset)
				if actors[i].get_name() == "Enemy":
					tween_x[i] = 1.7
		else:
			# Just set their position immediately
			for i in range(actors.size()):
				actors_x[i] = 0.6 + (i*offset)
				if actors[i].get_name() == "Enemy":
					actors_x[i] = 1.7
	elif pos == 2:
		if tween:
			for i in range(actors.size()):
				tween_x[i] = 1.4 - (i*offset)
				if actors[i].get_name() == "Enemy":
					tween_x[i] = 0.3
				#$BattleTween.interpolate_property(self, "actors_x", actors_x, tween_x, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
				#$BattleTween.interpolate_property($BattleTween, "value", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
			#$BattleTween.start()
			#tweening = true
		else:
			# Just set their position immediately
			for i in range(actors.size()):
				actors_x[i] = 1.4 - (i*offset)
				if actors[i].get_name() == "Enemy":
					actors_x[i] = 0.3



