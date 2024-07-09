extends CharacterBody2D

@export var speed: float = 40

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	velocity = Vector2.from_angle((randi_range(0,3) * PI/2) + PI/4) * speed

func _physics_process(delta: float) -> void:
	sprite.flip_h = velocity.x < 0
	sprite.flip_v = velocity.y < 0

