extends CharacterBody2D

@export var free_time :int
const SPEED = 300.0
const B = 1.2

var isS = false
var shootDir = Vector2.ZERO

var gpu = load("res://粒子/firebal_gpu.tscn")

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.2)
	await get_tree().create_timer(free_time).timeout
	queue_free()

func _physics_process(delta: float) -> void: 
	look_at(global_position + velocity)
	if isS:
		isS = false
		var dir = (shootDir - global_position).normalized()
		velocity = dir * SPEED
		
		look_at(global_position + velocity)
	
	var col = move_and_collide(velocity * delta)
	if col:
		SoundManager.play_sfx("mirror")
		velocity = velocity.bounce(col.get_normal())
		velocity *= B
		look_at(global_position + velocity)
		
		var GPU = gpu.instantiate()
		GPU.global_position = self.global_position
		GPU.emitting = true
		get_parent().add_child(GPU)
		
		var tween := create_tween()
		tween.tween_property(self, "scale", Vector2(0.3,0.3), 0.1)
		tween.tween_property(self, "scale", Vector2(0.5,0.5), 0.1)
		
