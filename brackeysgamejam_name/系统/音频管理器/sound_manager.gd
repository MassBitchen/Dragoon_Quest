extends Node

enum Bus { MASTER, SFX, BGM }
@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

func play_sfx(name: String) -> void:
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	player.play()

func stop_sfx(name: String) -> void:
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	player.stop()

func play_bgm(stream: AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()

func stop_bgm(stream: AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.stop()

func set_volume(bus_index: int, v: float) -> void:
	var db := linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index, db)
