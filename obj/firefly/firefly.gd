extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.frame == 0:
		velocity.y += 24
	if sprite.frame == 2:
		velocity.y -= 24
