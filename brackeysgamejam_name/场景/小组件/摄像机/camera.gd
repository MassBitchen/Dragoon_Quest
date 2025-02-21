extends Camera2D

@export var recovery_speed := 16.0
@export var k :float = 0.02
@export var p :Vector2 = Vector2(9,-400)

var strength := 0.0
var PlayerPos :Vector2
var t = true

func _ready() -> void:
	Game.camera_should_shake.connect(func (amount: float):
		strength += amount
	)
	Game.connect("player_position_update", Callable(self,"_on_player_position_update"))
	Game.connect("should_reopen", Callable(self , "_on_should_reopen"))

func _process(delta: float) -> void:
	var p2 = self.global_position
	var p1 :Vector2
	if Input.get_action_strength("attack"):
		p1 = (PlayerPos + get_global_mouse_position())/2
	else:
		p1 = PlayerPos + p
	p2 += (p1 - p2) * k
	self.global_position = p2

	offset = Vector2(
		randf_range(-strength, +strength),
		randf_range(-strength, +strength)
	)
	strength = move_toward(strength, 0, recovery_speed * delta)

#信号
func _on_player_position_update(PlayerPosition):
	PlayerPos = PlayerPosition

func _on_should_reopen() -> void:
	pass
