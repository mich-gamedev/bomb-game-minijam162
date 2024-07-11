extends Node2D

var speed: float = -75
var velocity: Vector2
var gravity: Vector2 = Vector2(0, 200)
var start_pos: Vector2
var maxHeight: bool = false
var timer: float = 0
var time_to_destroy: int = 5

func _ready():
	start_pos = global_position
	
	velocity = Vector2(randf_range(-0.4, 0.4), 1).normalized() * speed

func _process(delta):
	velocity += gravity * delta * Upgrades.current.player_gravity
	global_position += velocity * delta
	timer += delta
	if timer >= time_to_destroy:
		queue_free()
