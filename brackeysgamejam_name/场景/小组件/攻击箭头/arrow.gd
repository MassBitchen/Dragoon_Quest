extends Sprite2D

var mouse_direction

func _process(delta: float) -> void:
	mouse_direction = (get_global_mouse_position() - self.global_position).normalized()
	self.rotation = mouse_direction.angle()
