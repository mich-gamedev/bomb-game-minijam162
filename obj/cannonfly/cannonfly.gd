extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire_bullet: FireBullet = $FireBullet
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $JumpParticle/AnimationPlayer
@onready var jump_particle: Sprite2D = $JumpParticle


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 64 * delta)

func _on_timer_timeout() -> void:
	var rand_dir = [1,-1,-1].pick_random()
	var player = get_tree().get_first_node_in_group(&"player")
	var dir_to_player = global_position.direction_to(player.global_position)
	sprite.flip_v = (dir_to_player * rand_dir).x < 0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "rotation", (dir_to_player * rand_dir).angle(), 0.66)
	await tween.finished
	sprite.play(&"fire")


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.frame == 5:
		jump_particle.global_position = global_position + (Vector2(5,0).rotated(rotation))
		jump_particle.rotation = rotation + (PI/2)
		anim.play(&"hit")
		fire_bullet.fire(rotation)
		velocity = Vector2.from_angle(rotation) * -96
		timer.start()
		await sprite.animation_finished
		sprite.play(&"idle")

