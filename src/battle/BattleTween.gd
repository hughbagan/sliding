extends Tween

var value : float = 0.0
var obj # the object to Tween (probably the "Battle" node)


func _physics_process(delta):
	if obj.get_name() == "Battle":
		for i in range(obj.actors_x.size()):
			obj.actors_x[i] += delta
			if obj.actors_x[i] >= (obj.tween_x[i] - 0.1):
				obj.actors_x[i] = obj.tween_x[i]
				emit_signal("tween_completed")


func set_tween_property(o):
	obj = o
