extends Bullet

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var node_pooler: NodePooler = $NodePooler

func unstash_item(pooler: NodePooler, pool: StringName):
	bounces_left = Upgrades.current.bomb_bounces

func _process(delta: float) -> void:
	velocity.y += 240 * delta * Upgrades.current.bomb_gravity

func _on_bounced() -> void:
	var inst = node_pooler.grab_available_object()
	inst.get_node("Hurtbox").damage = Upgrades.current.bomb_damage
	inst.global_position = global_position
	inst.scale = Vector2.ONE * Upgrades.current.explosion_radius
