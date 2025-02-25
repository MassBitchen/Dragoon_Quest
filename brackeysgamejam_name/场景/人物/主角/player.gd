class_name Player
extends CharacterBody2D
#组件
@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_eye: AnimatedSprite2D = $Body/PlayerEye
@onready var sprite_2d: Sprite2D = $Body/Sprite2D
@onready var attack_gpu: GPUParticles2D = $Body/Attack_GPU
@onready var attack_gpu_2: GPUParticles2D = $Body/Attack_GPU_2
@onready var attack_light: PointLight2D = $Body/Attack_light
@onready var interacting_label: Label = $UI/interacting_label
@onready var arrow: Sprite2D = $arrow
@onready var attack_pos: Marker2D = $Body/Mark2D/attack_pos
@onready var attack_bar: TextureProgressBar = $Body/attack_bar
@onready var talk: Node2D = $Body/talk
@onready var talk_label: RichTextLabel = $Body/talk/talkLabel
#Timer
@onready var coyote_timer: Timer = $Timer/CoyoteTimer
@onready var jump_request_timer: Timer = $Timer/JumpRequestTimer
@onready var wink_timer: Timer = $Timer/WinkTimer
#可交互组件
var interacting_with: Array[Interactable]
#移动相关
#所有状态
enum State{
	IDLE,
	RUN,
	JUMP,
	FALL,
	ATTACK,
}
#方向
enum Direction {
	LEFT = -1,
	RIGHT = +1,
}
@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		body.scale.x = direction
const RUN_SPEED := 300.0
const FLOOR_ACCELERATION := RUN_SPEED / 0.02
const AIR_ACCELERATION := RUN_SPEED / 0.03
const JUMP_VELOCITY := -1000.0
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") * 2 as float
#玩家位置
var PlayerPosition :Vector2 = Vector2.ZERO
#实例场景
var BULLET = load("res://场景/人物/火球/fireball.tscn")
var reopen_path
var canmove := true
#预处理
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 3:
			velocity.y = JUMP_VELOCITY / 3
	if event.is_action_pressed("interact") and interacting_with:
		interacting_with.back().interact()
#ready
func _ready() -> void:
	randomize()
	Game.connect("player_talk", Callable(self , "_on_player_talk"))
#帧处理动画
func tick_physics(state: State, _delta: float) -> void:
	#
	talk_label.scale.x = direction
	#让攻击箭头位置正确
	arrow.global_position = attack_pos.global_position
	#判断交互提示是否出现
	#interacting_label.visible = !interacting_with.is_empty()
	#玩家位置发布，给怪物和相机寻路
	PlayerPosition = self.position
	Game.emit_signal("player_position_update",PlayerPosition)
	#穿越单向平台
	if Input.is_action_just_pressed("move_down"):
		self.global_position.y += 1
	match state:
		State.IDLE:
			Player_move(default_gravity, _delta, 1)
		State.RUN:
			Player_move(default_gravity, _delta, 1)
		State.JUMP:
			Player_move(default_gravity, _delta, 1)
		State.FALL:
			Player_move(default_gravity, _delta, 1)
		State.ATTACK:
			Player_AttackBar_move(_delta)
#状态机转状态
func get_next_state(state: State) -> int:
	var H_is_still := is_zero_approx(velocity.x)
	#实现跳跃
	var can_jump := is_on_floor() or coyote_timer.time_left > 0
	var should_jump := can_jump and jump_request_timer.time_left > 0
	if should_jump:
		return State.JUMP
	match state:
		State.IDLE:
			if not H_is_still:
				return State.RUN
			if Input.get_action_strength("attack"):
				return State.ATTACK
			if velocity.y > 0:
				return State.FALL
		State.RUN:
			if H_is_still:
				return State.IDLE
			if Input.get_action_strength("attack"):
				return State.ATTACK
			if velocity.y > 0:
				return State.FALL
		State.JUMP:
			if velocity.y > 0:
				return State.FALL
		State.FALL:
			if velocity.y == 0:
				return State.IDLE
		State.ATTACK:
			if not Input.get_action_strength("attack"):
				return State.IDLE
	return StateMachine.KEEP_CURRENT
#状态执行函数
func transition_state(from: State, to: State) -> void:
	if from == State.FALL:
		var tween := create_tween()
		tween.tween_property(sprite_2d, "scale", Vector2(0.5,0.4), 0.1)
		tween.tween_property(sprite_2d, "scale", Vector2(0.5,0.5), 0.1)
		var eye_tween := create_tween()
		eye_tween.tween_property(player_eye, "scale", Vector2(0.5,0.4), 0.1)
		eye_tween.tween_property(player_eye, "scale", Vector2(0.5,0.5), 0.1)
	if from == State.ATTACK:
		if attack_bar.value == 1:
			Player_Attack()
			var tween := create_tween()
			tween.tween_property(sprite_2d, "scale", Vector2(0.5,0.6), 0.1)
			tween.tween_property(sprite_2d, "scale", Vector2(0.5,0.5), 0.1)
			var eye_tween := create_tween()
			eye_tween.tween_property(player_eye, "scale", Vector2(0.5,0.6), 0.1)
			eye_tween.tween_property(player_eye, "scale", Vector2(0.5,0.5), 0.1)
		attack_gpu_2.emitting = false
		attack_gpu.emitting = false
		attack_light.enabled = false
		arrow.visible = false
		attack_bar.visible = false
		player_eye.visible = true
		attack_bar.value = 0
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.JUMP:
			animation_player.play("jump")
			play_sfx("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
			var tween := create_tween()
			tween.tween_property(sprite_2d, "scale", Vector2(0.4,0.5), 0.1)
			tween.tween_property(sprite_2d, "scale", Vector2(0.5,0.5), 0.1)
			var eye_tween := create_tween()
			eye_tween.tween_property(player_eye, "scale", Vector2(0.4,0.5), 0.1)
			eye_tween.tween_property(player_eye, "scale", Vector2(0.5,0.5), 0.1)
		State.FALL:
			animation_player.play("fall")
		State.ATTACK:
			animation_player.play("attack")
			velocity = Vector2.ZERO
			attack_gpu.emitting = true
			attack_light.enabled = true
			arrow.visible = true
			attack_bar.visible = true
			player_eye.visible = false
#移动方法---
func Player_move(gravity: float, delta: float, rate: float) -> void:
	if canmove:
		#返回一个+-1
		var movement := Input.get_axis("move_left", "move_right")
		#判断摩擦
		var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
		#限制速度
		velocity.x = move_toward(velocity.x, movement * RUN_SPEED * rate, acceleration * delta)
		if abs(velocity.y) <= -JUMP_VELOCITY:
			velocity.y += gravity * delta
			if velocity.y > 0:
				velocity.y += 0
		if not is_zero_approx(movement):
			direction = Direction.LEFT if movement < 0 else Direction.RIGHT
		move_and_slide()
#攻击进度条
func Player_AttackBar_move(delta) -> void:
	attack_bar.value = move_toward(attack_bar.value, 1, 0.01)
	if attack_bar.value == 1:
		attack_gpu_2.emitting = true
#攻击函数
func Player_Attack() -> void:
	play_sfx("fireball")
	var bullet = BULLET.instantiate()
	bullet.global_position = attack_pos.global_position
	bullet.free_time = 20
	#bullet.Speed = 1000
	var mouse_direction = (get_global_mouse_position() - attack_pos.global_position).normalized()
	#bullet.ShootPos = mouse_direction
	bullet.velocity = mouse_direction * RUN_SPEED * 4
	get_parent().add_child(bullet)
#非移动方法---
#交互进入
#死亡状态不能交互，需要判断还未加上去
func register_interactable(v: Interactable) -> void:
	if v in interacting_with:
		return
	interacting_with.append(v)
#交互退出
func unregister_interactable(v: Interactable) -> void:
	interacting_with.erase(v)
#音效播放
func play_sfx(name: String) -> void:
	SoundManager.play_sfx(name)
#信号---
#眨眼倒计时
func _on_wink_timer_timeout() -> void:
	player_eye.play("wink")
	wink_timer.wait_time = randf_range(3, 6)
#受伤
func _on_hurtbox_hurt(hitbox: Variant) -> void:
	Game.change_scene(reopen_path, {entry_point = "entry1"})
#玩家说话
func _on_player_talk(text) -> void:
	talk.show()
	canmove = false
	talk_label.text = text
	talk_label.visible_ratio = 0
	var tween := create_tween()
	tween.tween_property(talk_label, "visible_ratio", 1, 1)
	await get_tree().create_timer(3).timeout
	talk.hide()
	Game.animation_player.play("over")
	canmove = true
	
