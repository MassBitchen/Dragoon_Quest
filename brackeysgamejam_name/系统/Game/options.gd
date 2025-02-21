extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and self.visible:
		self.hide()
