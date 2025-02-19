extends Interactable

@export_file("*.tscn") var path: String
@export var entry_point: String

@onready var mark: Node2D = $mark

func interact() -> void:
	super()
	Game.change_scene(path, {entry_point=entry_point})
	SoundManager.play_sfx("door_open")
	await get_tree().create_timer(0.15).timeout
	SoundManager.play_sfx("door_close")

func _on_entry() -> void:
	mark.visible = true

func _on_quit() -> void:
	mark.visible = false
