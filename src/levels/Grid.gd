extends TileMap
# This script is used to bind the GridBox objects to the tilemap.

func _ready() -> void:
	for child in get_children():
		if child is GridBox:
			child.initialize(self)
