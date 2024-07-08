extends AudioStreamPlayer2D



func _on_hurtbox_hitbox_entered(hitbox: Hitbox) -> void:
	play()
