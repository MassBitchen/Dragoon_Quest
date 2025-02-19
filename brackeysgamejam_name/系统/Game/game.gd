extends CanvasLayer
#组件
@onready var color_rect: ColorRect = $ColorRect
#信号
signal camera_should_shake(amount: float)
#玩家位置信号
signal player_position_update()

var world_states := {}	

func _ready() -> void:
	color_rect.color.a = 0
#摇相机
func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)
#场景变化
func change_scene(path: String, params := {}) -> void:
	var duration := params.get("duration", 0.2) as float
	
	var tree := get_tree()
	tree.paused = true
	
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, duration)
	await tween.finished
	
	#场景保存相关
	if tree.current_scene is World:
		var old_name := tree.current_scene.scene_file_path.get_file().get_basename()
	tree.change_scene_to_file(path)
	await tree.tree_changed
	tree.paused = false
	if tree.current_scene is World:
		#场景保存相关
		var new_name := tree.current_scene.scene_file_path.get_file().get_basename()
		if new_name in world_states:
			tree.current_scene.from_dict(world_states[new_name])
		#######新添加代码
		await tree.process_frame
		if "entry_point" in params:
			for node in tree.get_nodes_in_group("entry_points"):
				if node.name == params.entry_point:
					tree.current_scene.update_player(node.global_position, node.direction)
					break
		if "position" in params and "direction" in params:
			tree.current_scene.update_player(params.position, params.direction)
			######
	
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, duration)
	
