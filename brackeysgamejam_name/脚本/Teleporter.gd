extends Area2D
class_name Teleporter

@export_file("*.tscn") var path: String
@export var entry_point: String

func _init() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerBody":
		Game.change_scene(path, {entry_point=entry_point})
