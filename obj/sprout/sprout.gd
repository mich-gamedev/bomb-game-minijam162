extends CharacterBody2D

@export var speed: float
@export var gravity: float
@export var terminal_velocity: float
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var node_pooler: NodePooler = $NodePooler
@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast


func _ready() -> void:
	velocity.x = speed * [-1,1].pick_random()
	sprite.flip_h = velocity.x < 0

func _physics_process(delta: float) -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	if velocity.y < 0: velocity.y = 0
	if left_raycast.is_colliding():
		velocity.x = speed
		sprite.flip_h = false
	if right_raycast.is_colliding():
		velocity.x = -speed
		sprite.flip_h = true
	move_and_slide()

func _on_health_died() -> void:
	var inst = node_pooler.grab_available_object()
	inst.global_position = ((global_position/8.0).round() * 8.0) - Vector2(4,4)

