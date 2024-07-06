extends CharacterBody2D
class_name Bullet

@export var hurtbox: Hurtbox
@export var bounces: int

@onready var bounces_left = bounces

var pooler: NodePooler

signal bounced

func _physics_process(delta: float) -> void:
	var coll_info = move_and_collide(velocity * delta)
	if coll_info:
		bounced.emit()
		if bounces_left:
			bounces_left -= 1
			velocity = velocity.bounce(coll_info.get_normal())
		else:
			if !is_instance_valid(pooler):
				queue_free()
			else:
				pooler.stash(self)

func stash_item(pooler: NodePooler, pool_name: StringName) -> void:
	pass

func unstash_item(p: NodePooler, pool_name: StringName) -> void:
	pass
