extends Playercheckbox

@export var text: String
@onready var text_label: Label = $textLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	text_label.text = text

func _on_ischeck() -> void:
	animation_player.play("open")

func _on_nocheck() -> void:
	animation_player.play("close")
