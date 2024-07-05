extends PooledItem2D

@onready var node_pooler: NodePooler = $NodePooler

func _on_health_died() -> void:
	node_pooler.stash(self)
