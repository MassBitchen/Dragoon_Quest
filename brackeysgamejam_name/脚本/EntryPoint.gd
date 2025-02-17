extends Marker2D
class_name EntryPoint

@export var direction := Player.Direction.RIGHT

func _ready() -> void:
	add_to_group("entry_points")
