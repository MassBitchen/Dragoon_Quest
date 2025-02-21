extends Interactable

@export_file("*.tscn") var path: String
@export var entry_point: String
@export var isopen :bool = false

@onready var mark: Node2D = $mark
@onready var sprite_2d: Sprite2D = $body/Sprite2D
@onready var sprite_2d_2: Sprite2D = $body/Sprite2D2
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if get_parent().get_parent().enemy_num == 0:
		isopen = true
	sprite_2d_2.visible = not isopen
	collision_shape_2d.disabled = sprite_2d_2.visible

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
