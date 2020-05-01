extends TileMap
# This script is used to 

func _ready() -> void:
	for child in get_children():
		
		if child is GridBox:
			# Bind the GridBox objects to the tilemap.
			child.init_grid(self)
		
		if child is BoxButton:
			# In order to bind a BoxButton to a Door, first we need
			# to find its corresponding door.
			var found = false
			for another_child in get_children():
				if another_child is Door:
					if another_child.id == child.id:
						found = true
						child.connect("pressed", another_child, "open")
						child.connect("unpressed", another_child, "close")
						# Excluding a `break` here means that a BoxButton
						# can be connected to multiple Doors.
			if not found:
				print("WARNING: BoxButton ", child.id, " could not find a Door")
