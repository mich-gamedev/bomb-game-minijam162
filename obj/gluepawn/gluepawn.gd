extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var jump_timer = $JumpTimer

@export var jump_force: float = 160
@export var friction: float = 480
@export var time_range: Vector2 = Vector2(1, 5)
@export var gravity: float
@export var terminal_velocity: float

const land_anims : Array[StringName] = [&"charge", &"idle", &"land"]
const air_anims : Array[StringName] = [&"fall", &"jump"]

func _physics_process(delta: float) -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		if sprite.animation in air_anims:
			sprite.play(&"land")
			jump_timer.start(randf_range(time_range.x, time_range.y))
	else:
		if velocity.y < 0 and sprite.animation != &"jump": sprite.play(&"jump")
		if velocity.y > 0 and sprite.animation != &"fall": sprite.play(&"fall")
	if is_on_wall():
		print("gluepawn on wall")
		velocity.x = sign(-velocity.x) * 256
	move_and_slide()

func jump() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group(&"player") as CharacterBody2D
	var direction = global_position.direction_to(player.global_position + (Vector2.UP * 128)).normalized()
	velocity = direction.rotated(deg_to_rad(randf_range(-5,5))) * jump_force

func _on_animated_sprite_2d_animation_finished() -> void:
	match sprite.animation:
		&"land":
			sprite.play(&"idle")
		&"charge":
			jump()


func _on_jump_timer_timeout() -> void:
	sprite.play(&"charge")
