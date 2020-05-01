class_name Door extends KinematicBody2D


export var id : float # eg. 1.1, 1.2, 2.1, 2.2, 2.3...


func open() -> void:
	$Sprite.hide()
	$CollisionShape2D.call_deferred("set_disabled", true) #disabled = true #set_disabled(true)


func close() -> void:
	$Sprite.show()
	$CollisionShape2D.call_deferred("set_disabled", false) #disabled = false #set_disabled(false)

