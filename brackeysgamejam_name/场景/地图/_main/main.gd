extends World

@onready var title: RichTextLabel = $title
@onready var title_open: Playercheckbox = $Area/title_open

func _ready() -> void:
	super()


func _on_title_open_ischeck() -> void:
	var tween := create_tween()
	tween.tween_property(title, "modulate", Color(1,1,1,1), 5)
	title_open.queue_free()


func _on_camera_area_1_ischeck() -> void:
	camera_2d.p = Vector2(0,-200)

func _on_camera_area_2_ischeck() -> void:
	camera_2d.p = Vector2(0,0)


#调试内容
func _on_area_2d_area_entered(area: Area2D) -> void:
	Game.change_scene("res://场景/地图/_end/end.tscn", {entry_point="end"})
