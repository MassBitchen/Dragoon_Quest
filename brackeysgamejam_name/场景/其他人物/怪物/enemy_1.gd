extends CharacterBody2D
#组件
@onready var body: Node2D = $body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floorcheck: RayCast2D = $body/floorcheck
@onready var wallcheck: RayCast2D = $body/wallcheck
#所有状态
enum State{
	IDLE,
	RUN,
	DIE,
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
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") * 2 as float
#ready
func _ready() -> void:
	randomize()
#帧处理动画
func tick_physics(state: State, _delta: float) -> void:
	match state:
		State.IDLE:
			Enemy_move(_delta)
		State.RUN:
			Enemy_move(_delta)
		State.DIE:
			pass
#状态机转状态
func get_next_state(state: State) -> int:
	match state:
			State.IDLE:
				if not velocity == Vector2.ZERO:
					return State.RUN
			State.RUN:
				pass
			State.DIE:
				pass
	return StateMachine.KEEP_CURRENT
#状态执行函数
func transition_state(from: State, to: State) -> void:
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.DIE:
			animation_player.play("die")
#巡逻函数
func Enemy_move(delta: float) -> void:
	velocity.x = move_toward(velocity.x, -RUN_SPEED * direction, FLOOR_ACCELERATION * delta)
	velocity.y += default_gravity * delta * 1.5
	if wallcheck.is_colliding() or not floorcheck.is_colliding():
		direction *= -1
	move_and_slide()


func _on_hurtbox_hurt(hitbox: Variant) -> void:
	get_parent().get_parent().enemy_num -= 1
	queue_free()
