extends Node2D

onready var center :Vector2 = $Center.get_position()
var oval_radius := Vector2(270.0, 15.0) # the ellipse that the actors move along
onready var actors := [$YSort/Char1, $YSort/Enemy]
onready var actors_min := Vector2(center.x - oval_radius.x, center.y - oval_radius.y)
onready var actors_max := Vector2(center.x + oval_radius.x, center.y + oval_radius.y)
var actor_x_offset := 0.1

var tween_x := []
var tweening := false
var tween_speed := 1.7 # in seconds

var first_pos = [0.65, 1.65]	# Players in front, Enemy in behind
var second_pos = [1.3, 0.3] # Players behind, Enemy in front


func _ready():
	# Initialize
	for i in range(actors.size()):
		tween_x.append(0.0)
	actors_set_position(first_pos, true)
	$Background.set_offset(Vector2(0.0, 0.0))


func _physics_process(delta):
	# Get input, which affects x
	if Input.is_action_pressed("ui_left"):
		for i in range(actors.size()):
			actors[i].x -= 0.01
			$Background.set_offset(Vector2($Background.get_offset().x + 2, 0))
	elif Input.is_action_pressed("ui_right"):
		for i in range(actors.size()):
			actors[i].x += 0.01
			$Background.set_offset(Vector2($Background.get_offset().x - 2, 0))
	elif Input.is_action_just_pressed("1"):
		actors_set_position(first_pos, true)
		$BackgroundTween.interpolate_property($Background, "offset", $Background.offset, Vector2(0.0, 0.0), tween_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$BackgroundTween.start()
	elif Input.is_action_just_pressed("2"):
		actors_set_position(second_pos, true)
		$BackgroundTween.interpolate_property($Background, "offset", $Background.offset, Vector2(-500.0, 0.0), tween_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$BackgroundTween.start()
	
	# Run the x vars through the trig expressions to get actual position coordinates.
	# This is crucial for allowing the x vars tweening to work.
	for i in range(actors.size()):
		actors[i].set_position(oval_position(oval_fraction_x(actors[i].x), oval_fraction_y(actors[i].x)))


func oval_fraction_x(x:float) -> float:
	"""
	Calculates a decimal that represents a fraction of the oval's radius width (x).
	"""
	return cos(PI*x + PI) + 1


func oval_fraction_y(x:float) -> float:
	"""
	Calculates a decimal that represents a fraction of the oval's radius height (y).
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


func actors_set_position(pos:Array, tween:bool=false):
	"""
	Tweens the x vars of the actors. These vars are run through trig functions 
	elsewhere to set the actual positions of the actors.
	pos   - x variables around the oval to be set.
			pos[0] = Party actors ; pos[1] Enemy actors
	tween - whether or not to tween the positions or just set them immediately
	"""
	if tween:
		for i in range(actors.size()):
			var tweenpoint
			if actors[i].get_name() == "Enemy":
				# Set the position on the oval for an enemy actor
				tweenpoint = pos[1]
			else:
				# Set the position on the oval for a party actor
				tweenpoint = pos[0] - (i*actor_x_offset)
			# Edge case: rotating past the (trig function's) period of the oval
			if abs(actors[i].x-(tweenpoint+2)) < abs(actors[i].x-tweenpoint):
				tween_x[i] = tweenpoint+2
			else:
				tween_x[i] = tweenpoint
			# Finally, schedule it to Tween the actor's "x" property.
			$BattleTween.interpolate_property(actors[i], "x", actors[i].x, tween_x[i], tween_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$BattleTween.start()
		tweening = true
	else:
		# Just set their position immediately
		for i in range(actors.size()):
			actors[i].x = pos[0] - (i*actor_x_offset)
			if actors[i].get_name() == "Enemy":
				actors[i].x = pos[1]


func _on_BattleTween_tween_all_completed():
	tweening = false
	print("Done tweening!")
