class_name LevelLoader extends Node2D
# Class description


var cache = []
var current_level = null


func _ready() -> void:
	pass


func load_level(level_name:String, parent:Node) -> void:
	var level_path = "res://src/levels/"+level_name+".tscn"
	
	# Remove the current level from the SceneTree
	if current_level == null:
		print("WARNING: current_level is null")
		#get_tree().quit()
	else:
		# Check for a redundant call
		if level_path == current_level.get_filename():
			print("WARNING: Tried to load the current "+level_name)
			return
		current_level.get_parent().call_deferred("remove_child", current_level)
	
	# If the scene has been instanced, then add it to the SceneTree.
	for level in cache:
		if level.get_filename() == level_path:
			parent.call_deferred("add_child", level)
			current_level = level
			print("LOADED: ", level_name)
			return
	
	# Otherwise: instance it, append to cache, and add it to the SceneTree.
	var new_level = load(level_path).instance()
	cache.append(new_level)
	parent.call_deferred("add_child", new_level)
	current_level = new_level
	print("LOADED: ", level_name)

