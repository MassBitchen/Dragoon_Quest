extends AnimatedSprite2D

@export var free_time :int
@export var normal_damage :float
@onready var fire_ball: Area2D = $fire_ball

var Speed
var ShootPos :Vector2

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.3)
	await get_tree().create_timer(free_time).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += ShootPos * Speed * delta
	self.rotation = ShootPos.angle()


func _on_fire_ball_area_entered(area: Area2D) -> void:
	var space_state = get_world_2d().direct_space_state
		
	var query = PhysicsRayQueryParameters2D.create(global_position, area.global_position)
		
	var result = space_state.intersect_ray(query)
	if result:
		var collision_normal = result.normal
		ShootPos = ShootPos .bounce(collision_normal)
		print("反射后的速度: ", ShootPos)
