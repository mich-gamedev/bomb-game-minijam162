extends PooledItem2D

@onready var node_pooler: NodePooler = $NodePooler
@onready var particle: GPUParticles2D = $GPUParticles2D
@onready var sfx_pooler: NodePooler = $SFXPooler

func unstash_item(pooler: NodePooler, pool: StringName) -> void:
	if !is_node_ready(): await ready
	particle.restart()

func _on_health_died() -> void:
	sfx_pooler.grab_available_object().global_position = global_position
	node_pooler.stash(self)
