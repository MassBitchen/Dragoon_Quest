extends "res://场景/小组件/门/door.gd"

func interact() -> void:
	super()
	Game.over = true
