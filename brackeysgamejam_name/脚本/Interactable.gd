extends Area2D
class_name Interactable

signal interacted
signal entry
signal quit

func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func interact() -> void:
	print("[Interact] %s" % name)
	interacted.emit()

func _on_body_entered(player: Player) -> void:
	player.register_interactable(self)
	entry.emit()

func _on_body_exited(player: Player) -> void:
	player.unregister_interactable(self)
	quit.emit()
