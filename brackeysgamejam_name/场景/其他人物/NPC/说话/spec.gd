extends Interactable

@onready var body: Node2D = $body
@onready var sprite_2d: Sprite2D = $body/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var sprite_2d_2: Sprite2D = $body/Sprite2D2
@onready var talk_label: Node2D = $talk_label
@onready var label: Label = $body/Sprite2D2/Label

@export var dir: int
@export_file("*.png") var texture
@export var text :String
#ready
func _ready() -> void:
	label.text = text
	randomize()
	body.scale.x = dir
	label.scale.x = dir
	sprite_2d.texture = load(texture)
func interact() -> void:
	if not animation_player_2.is_playing():
		animation_player_2.play("talk")

func _on_entry() -> void:
	talk_label.show()

func _on_quit() -> void:
	sprite_2d_2.hide()
	talk_label.hide()


func _on_hurtbox_hurt(hitbox: Variant) -> void:
	queue_free()
