extends World

@onready var title: RichTextLabel = $title
@onready var title_open: Playercheckbox = $Area/title_open
@onready var door_2: Area2D = $Door/door2
@onready var door_3: Area2D = $Door/door3
@onready var door_4: Area2D = $Door/door4
@onready var door_5: Area2D = $Door/door5
@onready var king: Area2D = $king

func _ready() -> void:
	super()
	if Game.over == true:
		king.scale.x = -1

func _physics_process(delta: float) -> void:
	door_2.isopen = Game.door2
	door_3.isopen = Game.door3
	door_4.isopen = Game.door4
	door_5.isopen = Game.door5

func _on_title_open_ischeck() -> void:
	var tween := create_tween()
	tween.tween_property(title, "modulate", Color(1,1,1,1), 5)
	title_open.queue_free()

func _on_camera_area_1_ischeck() -> void:
	camera_2d.limit_top = 120



func _on_camera_area_1_nocheck() -> void:
	camera_2d.limit_top = -10000
