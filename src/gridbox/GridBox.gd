class_name GridBox extends KinematicBody2D
# Originally written by guilhermehto on Github from gdquest.com
# Class Description


onready var MoveTween :Tween = $Tween
onready var spr_size : Vector2 = $Unpressed.texture.get_size()
var Grid :TileMap
var sliding := false
var throwing := false


func init_grid(_tilemap :TileMap) -> void:
	Grid = _tilemap
	position = calculate_destination(Vector2())


func push(direction :Vector2, sliding_time :float) -> void:
	if sliding:
		return
	# TODO: Is something fucky here with direction? (`push_time` in Player)
	var move_to := calculate_destination(direction.normalized())
	print(move_to)
	if can_move(move_to):
		MoveTween.interpolate_property(self,
			"global_position",
			global_position,
			move_to,
			sliding_time,
			Tween.TRANS_LINEAR,	# TRANS_CUBIC
			Tween.EASE_IN_OUT 	# EASE_OUT
		)
		MoveTween.start()
		sliding = true
		yield(MoveTween, "tween_completed")
		sliding = false


func throw(direction :Vector2, throwing_time :float) -> void:
	if throwing:
		return
	var space_state := get_world_2d().direct_space_state
	# assume direction is to the right, but will have to change later
	print(get_global_position(), OS.get_window_size())
	var ray_from := Vector2(get_global_position().x+spr_size.x, get_global_position().y+spr_size.y)
	var ray_to := Vector2(OS.get_window_size().x, get_global_position().y+spr_size.y)
	var result := space_state.intersect_ray(ray_from, ray_to, [self])
	print(result)
	#var move_to = calculate_destination(result.position)
	var move_to :Vector2 = result.position
	print(move_to)
	#if can_move(move_to):
	MoveTween.interpolate_property(self,
		"global_position",
		global_position,
		move_to,
		throwing_time,
		Tween.TRANS_LINEAR,	# TRANS_CUBIC
		Tween.EASE_IN_OUT 	# EASE_OUT
	)
	MoveTween.start()
	throwing = true
	yield(MoveTween, "tween_completed")
	throwing = false


func calculate_destination(direction: Vector2) -> Vector2:
	# Returns the global position from our position towards direction, snapped to the grid
	var tilemap_position = Grid.world_to_map(global_position) + direction
	return Grid.map_to_world(tilemap_position)


func can_move(move_to: Vector2) -> bool:
	# Returns if the box can be moved to `move_to` without causing a collision
	var future_transform : = Transform2D(transform)
	future_transform.origin = move_to
	return not test_move(future_transform, Vector2())


func on_BoxButton_pressed():
	$Pressed.show()
	$Unpressed.hide()


func on_BoxButton_unpressed():
	$Pressed.hide()
	$Unpressed.show()


