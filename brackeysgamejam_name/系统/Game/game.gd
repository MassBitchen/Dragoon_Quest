extends CanvasLayer
#组件
@onready var color_rect: ColorRect = $ColorRect
#信号
signal camera_should_shake(amount: float)
#玩家位置信号
signal player_position_update()

#摇相机
func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)
#场景变化
func change_scene(path: String, params := {}) -> void:
	var duration := params.get("duration", 0.2) as float
	var tree := get_tree()
	tree.change_scene_to_file(path)
	await tree.tree_changed
	if tree.current_scene is World:
		await tree.process_frame
		if "entry_point" in params:
			for node in tree.get_nodes_in_group("entry_points"):
				if node.name == params.entry_point:
					tree.current_scene.update_player(node.global_position, node.direction)
					break
		if "position" in params and "direction" in params:
			tree.current_scene.update_player(params.position, params.direction)
