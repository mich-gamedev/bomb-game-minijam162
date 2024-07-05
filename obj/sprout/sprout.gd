extends CharacterBody2D

@export var speed: float
@export var gravity: float
@export var terminal_velocity: float
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var node_pooler: NodePooler = $NodePooler
@onready var ray_cast: RayCast2D = $RayCast2D

func _ready() -> void:
	velocity.x = speed * [-1,1].pick_random()
	ray_cast.target_position.x = 8 * sign(velocity.x)
	sprite.flip_h = velocity.x < 0

func _physics_process(delta: float) -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	if ray_cast.is_colliding():
		velocity.x = -velocity.x
		sprite.flip_h = velocity.x < 0
		ray_cast.target_position.x = -ray_cast.target_position.x
		print(velocity.x)
	move_and_slide()

func _on_health_died() -> void:
	var inst = node_pooler.grab_available_object()
	inst.global_position = ((global_position/8.0).round() * 8.0) - Vector2(4,4)

