class_name Player
extends CharacterBody2D
#组件
@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#Timer
@onready var coyote_timer: Timer = $Timer/CoyoteTimer
@onready var jump_request_timer: Timer = $Timer/JumpRequestTimer
#可交互组件
var interacting_with: Array[Interactable]
#移动相关
#所有状态
enum State{
	IDLE,
	RUN,
	JUMP,
	FALL,
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
const RUN_SPEED := 120.0
const FLOOR_ACCELERATION := RUN_SPEED / 0.02
const AIR_ACCELERATION := RUN_SPEED / 0.03
const JUMP_VELOCITY := -320.0
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float
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
#帧处理动画
func tick_physics(state: State, _delta: float) -> void:
	#判断交互提示是否出现
	
	#玩家位置发布，给怪物寻路
	
	#穿越单向平台
	match state:
		State.IDLE:
			Player_move(default_gravity, get_process_delta_time(), 1)
		State.RUN:
			Player_move(default_gravity, get_process_delta_time(), 1)
		State.JUMP:
			Player_move(default_gravity, get_process_delta_time(), 1)
		State.FALL:
			Player_move(default_gravity, get_process_delta_time(), 1)
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
			pass
		State.RUN:
			pass
		State.JUMP:
			pass
		State.FALL:
			pass
	return StateMachine.KEEP_CURRENT
#状态执行函数
func transition_state(_from: State, to: State) -> void:
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.JUMP:
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
			animation_player.play("jump")
		State.FALL:
			animation_player.play("fall")
#移动方法---
func Player_move(gravity: float, delta: float, rate: float) -> void:
	#返回一个+-1
	var movement := Input.get_axis("move_left", "move_right")
	#判断摩擦
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	#限制速度
	velocity.limit_length(200)
	velocity.x = move_toward(velocity.x, movement * RUN_SPEED * rate, acceleration * delta)
	if abs(velocity.y) <= 330:
		velocity.y += gravity * delta
		if velocity.y > 0:
			velocity.y += 0
	if not is_zero_approx(movement):
		direction = Direction.LEFT if movement < 0 else Direction.RIGHT
	move_and_slide()
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
#信号---
