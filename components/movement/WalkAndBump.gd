class_name WalkAndBump extends Node

@export var actor: CharacterBody2D
@export var left_ray: RayCast2D
@export var right_ray: RayCast2D
@export var speed: float
@export var gravity: float
@export var terminal_velocity: float

signal bump_left
signal bump_right

func _ready() -> void:
	pick_dir()

func pick_dir() -> void:
	actor.velocity.x = speed * [-1,1].pick_random()

func _physics_process(delta: float) -> void:
	if is_zero_approx(actor.velocity.x): pick_dir()
	actor.velocity.y = move_toward(actor.velocity.y, terminal_velocity, gravity * delta)
	if left_ray.is_colliding():
		actor.velocity.x = speed
		bump_left.emit()
	if right_ray.is_colliding():
		actor.velocity.x = -speed
		bump_right.emit()
	actor.move_and_slide()
