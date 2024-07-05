class_name AnimateOnStash2D extends PooledItem2D

@export var anim: AnimationPlayer
@export var anim_name: StringName

func unstash_item(pooler: NodePooler, pool: StringName) -> void:
	anim.play(anim_name)
	await anim.animation_finished
	pooler.stash(self)
