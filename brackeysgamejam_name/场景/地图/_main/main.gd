extends World

@onready var title: RichTextLabel = $title

func _ready() -> void:
	super()
	
	var tween := create_tween()
	tween.tween_property(title, "position", Vector2(6,90), 0.7)
