extends CanvasLayer
#组件
@onready var color_rect: ColorRect = $ColorRect
@onready var level_name: Label = $level_name
#信号
signal camera_should_shake(amount: float)
#玩家位置信号
signal player_position_update()
#重开逻辑信号
signal should_reopen()
#重开逻辑信号
signal player_talk(text: String)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var door2 :bool = false
var door3 :bool = false
var door4 :bool = false
var door5 :bool = false
var over: bool = false

@onready var options: CanvasLayer = $options

var world_states := {}	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and not options.visible:
		options.show()

func _ready() -> void:
	color_rect.color.a = 0
	options.visibility_changed.connect(func ():
		get_tree().paused = options.visible
	)
#摇相机
func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)
#场景变化
func change_scene(path: String, params := {}) -> void:
	var duration := params.get("duration", 0.6) as float
	
	var tree := get_tree()
	tree.paused = true
	
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, duration/2)
	await tween.finished
	Engine.time_scale = 1
	
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
	tween.tween_property(color_rect, "color:a", 0, duration*2)

func play_level_name(text: String) -> void:
	level_name.text = text
	var tween := create_tween()
	tween.tween_property(level_name, "modulate", Color(1,1,1,1), 0.4)
	tween.tween_property(level_name, "modulate", Color(1,1,1,1), 3)
	tween.tween_property(level_name, "modulate", Color(1,1,1,0), 0.4)


func _on_reopen_pressed() -> void:
	options.hide()
	emit_signal("should_reopen")


func _on_back_pressed() -> void:
	options.hide()


func _on_main_pressed() -> void:
	options.hide()
	change_scene("res://场景/地图/_main/main.tscn",{entry_point = "entry1"})

func over_game() -> void:
	Game.change_scene("res://场景/地图/_end/end.tscn", {entry_point="end"})
