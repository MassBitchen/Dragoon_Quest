class_name World
extends Node2D

var player = load("res://场景/人物/主角/player.tscn")
@onready var camera_2d: Camera2D = $Camera

func update_player(pos : Vector2, direction : Player.Direction) -> void:
	camera_2d.global_position = pos
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()
	player = player.instantiate()
	player.global_position = pos
	player.name = "Player"
	add_child(player)
