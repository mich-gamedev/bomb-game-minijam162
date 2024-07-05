extends Bullet

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var node_pooler: NodePooler = $NodePooler

func _process(delta: float) -> void:
	velocity.y += 240 * delta * Upgrades.current.bomb_gravity

func _on_bounced() -> void:
	var inst = node_pooler.grab_available_object()
	inst.global_position = global_position
