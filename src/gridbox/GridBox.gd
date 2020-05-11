class_name GridBox extends KinematicBody2D
# push() written by guilhermehto on Github from gdquest.com
# Class Description


var Grid : TileMap
var cell_size : Vector2
var sliding := false
var throwing := false
# NOTE: Player.gd has a variable of the same name:
var throw_cast_length : float = min(OS.get_window_size().x, OS.get_window_size().y)*0.5


func init_grid(_tilemap :TileMap) -> void:
	Grid = _tilemap
	cell_size = _tilemap.cell_size
	position = calculate_destination(Vector2())


func _ready():
	$ThrowRayCast.force_raycast_update()
	#print(self, " ", $ThrowRayCast.get_collider())


func push(direction :Vector2, sliding_time :float) -> void:
	if sliding:
		return
	# TODO: Is something fucky here with direction? (`push_time` in Player)
	var move_to := calculate_destination(direction.normalized())
	if can_move(move_to):
		$MoveTween.interpolate_property(self,
			"global_position",
			global_position,
			move_to,
			sliding_time,
			Tween.TRANS_LINEAR,	# TRANS_CUBIC
			Tween.EASE_IN_OUT 	# EASE_OUT
		)
		$MoveTween.start()
		sliding = true
		yield($MoveTween, "tween_completed")
		sliding = false


func calculate_destination(direction: Vector2) -> Vector2:
	# Returns the global position from our position towards direction, snapped to the grid
	var tilemap_position = Grid.world_to_map(global_position) + direction
	return Grid.map_to_world(tilemap_position)


func can_move(move_to: Vector2) -> bool:
	# Returns if the box can be moved to `move_to` without causing a collision
	var future_transform : = Transform2D(transform)
	future_transform.origin = move_to
	return not test_move(future_transform, Vector2())


func throw(throw_direction:int) -> void:
	# This func raycasts in a given direction and Tweens self to it.
	$ThrowRayCast.set_enabled(true)
	if throwing:
		return
	# Set raycast direction that's obtained from input in Player
	var ray_to : Vector2
	if throw_direction == Global.Direction.RIGHT:
		ray_to = Vector2(throw_cast_length, 0)
	elif throw_direction == Global.Direction.LEFT:
		ray_to = Vector2(-throw_cast_length, 0)
	elif throw_direction == Global.Direction.UP:
		ray_to = Vector2(0, -throw_cast_length)
	elif throw_direction == Global.Direction.DOWN:
		ray_to = Vector2(0, throw_cast_length)
	$ThrowRayCast.set_cast_to(ray_to)
	# Now throw the raycast and get the resulting collider
	$ThrowRayCast.force_raycast_update()
	var collider = $ThrowRayCast.get_collider()
	var move_to : Vector2 = $ThrowRayCast.get_collision_point()
	print("THROW TO: ", collider.get_class(), " ", move_to)
	# Make adjustments to the end position based on WHAT we're colliding with
	if collider.has_method("throw"): # GridBox
		if throw_direction == Global.Direction.RIGHT:
			move_to = Vector2(move_to.x - (1+cell_size.x), move_to.y - cell_size.y*0.5)
		elif throw_direction == Global.Direction.LEFT:
			move_to = Vector2(move_to.x + 1, move_to.y - cell_size.y*0.5)
		elif throw_direction == Global.Direction.UP:
			move_to = Vector2(move_to.x - cell_size.x*0.5, move_to.y - 1)
		elif throw_direction == Global.Direction.DOWN:
			move_to = Vector2(move_to.x - cell_size.x*0.5, move_to.y - (1+cell_size.y))
	elif collider.has_method("_physics_process"): # Player
		# Round our destination to the nearest cell coordinate
		if throw_direction == Global.Direction.RIGHT or throw_direction == Global.Direction.LEFT:
			var rounded :float = round(move_to.x / cell_size.x) * cell_size.x
			move_to = Vector2(rounded, move_to.y)
			# Now adjust for the collision shapes...
			if throw_direction == Global.Direction.LEFT:
				move_to = Vector2(move_to.x, move_to.y - (cell_size.y*0.5))
			elif throw_direction == Global.Direction.RIGHT:
				move_to = Vector2(move_to.x - cell_size.x, move_to.y - (cell_size.y*0.5))
		elif throw_direction == Global.Direction.UP or throw_direction == Global.Direction.DOWN:
			var rounded :float = round(move_to.y / cell_size.y) * cell_size.y
			move_to = Vector2(move_to.x, rounded)
			# Now adjust for the collision shapes...
			if throw_direction == Global.Direction.UP:
				move_to = Vector2(move_to.x - (cell_size.x*0.5), move_to.y)
			elif throw_direction == Global.Direction.DOWN:
				move_to = Vector2(move_to.x - (cell_size.x*0.5), move_to.y - cell_size.y)
	else:
		# Throwing ourselves at the TileMap
		if throw_direction == Global.Direction.RIGHT:
			move_to = Vector2(move_to.x - cell_size.x, move_to.y - cell_size.y*0.5)
		elif throw_direction == Global.Direction.LEFT:
			move_to = Vector2(move_to.x, move_to.y - cell_size.y*0.5)
		elif throw_direction == Global.Direction.UP:
			move_to = Vector2(move_to.x - cell_size.x*0.5, move_to.y)
		elif throw_direction == Global.Direction.DOWN:
			move_to = Vector2(move_to.x - cell_size.x*0.5, move_to.y - cell_size.y)
	# Tween ourselves to the final destination
	$MoveTween.interpolate_property(self,
		"global_position",
		global_position,
		move_to,
		0.2, # throwing time
		Tween.TRANS_CUBIC, # TRANS_CUBIC
		Tween.EASE_IN # EASE_OUT
	)
	$MoveTween.start()
	throwing = true
	yield($MoveTween, "tween_completed")
	throwing = false
	$ThrowRayCast.set_enabled(false)

