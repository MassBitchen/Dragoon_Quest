extends Interactable

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var talk_label: Node2D = $talk_label
@onready var animated_sprite_2d: AnimatedSprite2D = $body/AnimatedSprite2D
@onready var talk_sp: Sprite2D = $"body/国王对话框"

var talk = 1
var talk_2 = 1

func interact() -> void:
	super()
	if not Game.over == true:
		if talk == 1:
			animation_player.play("talk_11")
			animated_sprite_2d.play("talk")
			talk += 1
		elif talk == 2:
			animation_player.play("talk_21")
			animated_sprite_2d.play("talk")
			talk += 1
		elif talk == 3:
			animation_player.play("talk_31")
			animated_sprite_2d.play("talk")
			talk += 1
		elif talk == 4:
			animation_player.play("talk_41")
			animated_sprite_2d.play("talk")
	else:
		if talk_2 == 1:
			animation_player.play("talk_1")
			animated_sprite_2d.play("talk")
			talk_2 += 1
		elif talk_2 == 2:
			animation_player.play("talk_2")
			animated_sprite_2d.play("talk")
			talk_2 += 1
		elif talk_2 == 3:
			animation_player.play("talk_3")
			animated_sprite_2d.play("talk")
			talk_2 += 1
			await get_tree().create_timer(1.5).timeout
			Game.emit_signal("player_talk","No, there's still one left. ")


func _on_entry() -> void:
	talk_label.show()


func _on_quit() -> void:
	talk_label.hide()
	talk_sp.hide()
