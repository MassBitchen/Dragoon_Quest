extends World

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	Game.door2 = true

func _on_enemy_1_tree_exited() -> void:
	animation_player.play("open")
