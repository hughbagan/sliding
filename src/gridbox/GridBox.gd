class_name GridBox extends KinematicBody2D
# Originally written by guilhermehto on Github from gdquest.com
# Class Description

onready var MoveTween :Tween = $Tween
export var sliding_time := 0.20
var Grid :TileMap
var sliding := false


func init_grid(_tilemap :TileMap) -> void:
	Grid = _tilemap
	position = calculate_destination(Vector2())


func push(velocity :Vector2) -> void:
	if sliding:
		return
	# TODO: Is something fucky here with velocity? (`push_time` in Player)
	var move_to :Vector2 = calculate_destination(velocity.normalized())
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

