class_name GridBox extends KinematicBody2D
# Originally written by guilhermehto on Github from gdquest.com
# Class Description

onready var spr_size : Vector2 = $Unpressed.texture.get_size()
onready var MoveTween : Tween = $Tween
var Grid : TileMap
var sliding := false
var throwing := false


func init_grid(_tilemap :TileMap) -> void:
	Grid = _tilemap
	position = calculate_destination(Vector2())


func _ready():
	$ThrowRayCast.force_raycast_update()
	print(self, $ThrowRayCast.get_collider())


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


func throw() -> void:
	if throwing:
		return
	$ThrowRayCast.force_raycast_update()
	var collider = $ThrowRayCast.get_collider()
	var move_to : Vector2 = $ThrowRayCast.get_collision_point()
	#print(move_to, $ThrowRayCast.get_collider().position)
	print(collider.get_class())
	if collider.has_method("throw"):
		move_to = Vector2(move_to.x - (1+spr_size.x), move_to.y - 8)
	else:
		move_to = Vector2(move_to.x - spr_size.x, move_to.y - spr_size.y*0.5)
	MoveTween.interpolate_property(self,
		"global_position",
		global_position,
		move_to,
		0.2, # throwing time
		Tween.TRANS_CUBIC,	# TRANS_CUBIC
		Tween.EASE_IN 	# EASE_OUT
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


