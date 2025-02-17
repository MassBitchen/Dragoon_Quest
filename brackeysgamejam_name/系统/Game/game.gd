extends CanvasLayer
#组件
@onready var color_rect: ColorRect = $ColorRect
#信号
signal camera_should_shake(amount: float)

#摇相机
func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)
#场景变化
func change_scene(path: String, params := {}) -> void:
	var duration := params.get("duration", 0.2) as float
	var tree := get_tree()
	tree.change_scene_to_file(path)
