class_name GameWorld extends Node2D

export var first_level : String = "Level1"

func _ready():
	$LevelLoader.load_level(first_level, self)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$LevelLoader.load_level("Level2", self)

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_1:
			$LevelLoader.load_level("Level1", self)
		elif event.pressed and event.scancode == KEY_2:
			$LevelLoader.load_level("Level2", self)
