class_name World
extends Node

@onready var camera_2d: Camera2D = $Camera
@onready var player: Player = $Player
@export var text :String
@export_file("*.tscn") var self_path: String
@export var enemy_num :int = 2

@export var bgm: AudioStream

func _ready() -> void:
	if bgm:
		SoundManager.play_bgm(bgm)
	Game.play_level_name(text)
	Game.connect("should_reopen", Callable(self , "_on_should_reopen"))
	player.reopen_path = self_path

func update_player(pos : Vector2, direction : Player.Direction) -> void:
	camera_2d.global_position = pos
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()
	player.global_position = pos
	player.direction = direction
	player.name = "Player"

#信号
func _on_should_reopen() -> void:
	Engine.time_scale = 0.2
	Game.change_scene(self_path,{entry_point = "entry1"})
