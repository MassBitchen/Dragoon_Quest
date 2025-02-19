extends AnimatedSprite2D

@export var free_time :int
@export var normal_damage :float

var Speed
var ShootPos

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.3)
	self.rotation = ShootPos.angle()
	await get_tree().create_timer(free_time).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += ShootPos * Speed * delta
