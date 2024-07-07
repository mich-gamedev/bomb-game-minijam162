extends PooledItem2D

@onready var anim: AnimationPlayer = $Hurtbox/AnimationPlayer

func unstash_item(pooler: NodePooler, pool: StringName) -> void:
	scale = Vector2.ONE * Upgrades.current.explosion_radius
	if is_instance_valid(anim):
		anim.stop()
		anim.play(&"explode")
		await anim.animation_finished
		if is_instance_valid(pooler):
			pooler.stash(self)
			return
	queue_free()
