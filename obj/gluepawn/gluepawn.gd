extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var time_between_jumps = $TimeBetweenJumps

@export var jump_force: float = 5
@export var time_range: Vector2 = Vector2(1, 5)
@export var gravity: float
@export var terminal_velocity: float

var next_jump_vector: Vector2
var rng = RandomNumberGenerator.new()


func _ready():
	get_jump_vector()

func _physics_process(delta):
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	if sprite.get_animation() == "jump" and is_on_floor():
		sprite.play("land")
	if time_between_jumps.is_stopped() and sprite.get_animation() == "idle":
		sprite.play("charge")

func jump():
	sprite.play("jump")
	velocity = next_jump_vector

func get_jump_vector():
	var horizontal_range := jump_force/2
	var horizontal_vel := rng.randf_range(-horizontal_range, horizontal_range)
	next_jump_vector = Vector2(horizontal_vel, -(jump_force - horizontal_vel))
	if horizontal_vel > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	start_timer()

func start_timer():
	time_between_jumps.wait_time = rng.randf_range(time_range.x, time_range.y)
	time_between_jumps.start()


func _on_animated_sprite_2d_animation_finished():
	if sprite.get_animation() == "land":
		sprite.play("idle")
		get_jump_vector()
	if sprite.get_animation() == "charge":
		jump()
