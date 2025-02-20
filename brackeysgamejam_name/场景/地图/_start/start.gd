extends Node2D

func start_game() -> void:
	Game.change_scene("res://场景/地图/_main/main.tscn", {entry_point="newgame"})
