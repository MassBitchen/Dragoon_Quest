class_name World
extends Node

@onready var camera_2d: Camera2D = $Camera
@onready var player: Player = $Player

@export var bgm: AudioStream

func _ready() -> void:
	if bgm:
		SoundManager.play_bgm(bgm)

func update_player(pos : Vector2, direction : Player.Direction) -> void:
	print(1)
	camera_2d.global_position = pos
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()
	player.global_position = pos
	player.direction = direction
	player.name = "Player"
