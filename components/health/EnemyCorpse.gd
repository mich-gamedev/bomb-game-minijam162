extends Node2D

var speed: float = -2
var velocity: Vector2
var gravity: Vector2 = Vector2(0, 5)
var start_pos: Vector2
var maxHeight: bool = false
var rng = RandomNumberGenerator.new()

func _ready():
	start_pos = global_position
	
	velocity = Vector2(rng.randf_range(-0.4, 0.4), 1).normalized() * speed

func _process(delta):
	velocity += gravity * delta
	global_position += velocity