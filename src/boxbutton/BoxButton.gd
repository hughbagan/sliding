class_name BoxButton extends Area2D


export var id : float # eg. 1.1, 1.2, 2.1, 2.2, 2.3...
signal pressed
signal unpressed


func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is GridBox and body.has_method("on_boxbutton_pressed"):
		body.on_BoxButton_pressed()
	$Unpressed.hide()
	$Pressed.show()
	emit_signal("pressed")


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body is GridBox and body.has_method("on_boxbutton_unpressed"):
		body.on_BoxButton_unpressed()
	$Pressed.hide()
	$Unpressed.show()
	emit_signal("unpressed")

