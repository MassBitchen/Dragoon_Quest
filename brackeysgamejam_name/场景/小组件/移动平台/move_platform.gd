extends Node2D


@export var rate :float = 1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.speed_scale = rate
