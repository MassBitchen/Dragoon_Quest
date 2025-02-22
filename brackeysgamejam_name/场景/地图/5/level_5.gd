extends World

func _ready() -> void:
	super()
	Game.door5 = true
func _on_specx_tree_exited() -> void:
	enemy_num -= 1
