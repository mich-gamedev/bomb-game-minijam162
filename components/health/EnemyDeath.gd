extends Node2D

@export var dead_body: PackedScene
@export var custom_place: Node2D

@onready var fire_bullet = $FireBullet

func _on_health_died():
	if dead_body != null:
		var body_inst = dead_body.instantiate()
		if custom_place == null:
			body_inst.global_position = global_position
		else:
			body_inst.global_position = custom_place.global_position
		get_parent().get_parent().add_child(body_inst)
	fire_bullet.projectile_count = Upgrades.current.dropped_bombs_on_death
	fire_bullet.fire_from_enemy(PI/2)
	
