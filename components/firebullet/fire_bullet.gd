class_name FireBullet extends Node2D

@export var speed: float = 128
@export var damage: float = 1.0
@export_range(1,10,1,"or_greater") var projectile_count: int
@export_range(0,360,0.01, "radians_as_degrees") var projectile_range: float = PI/4
@export var timer: Timer
@export var pooler: NodePooler

func fire(angle: float) -> void:
	if !is_instance_valid(timer) or timer.time_left == 0:
		if is_instance_valid(timer): timer.start()
		for i in projectile_count + 1:
			var bullet = pooler.grab_available_object()
			bullet.global_position = global_position
			if bullet is Bullet:
				if bullet.hurtbox: bullet.hurtbox.damage = damage
				if projectile_count + 1 > 1:
					var new_angle = (angle + (i * projectile_range / float(projectile_count))) - (projectile_range / 2.0)
					bullet.velocity = Vector2.from_angle(new_angle) * speed
				else:
					bullet.velocity = Vector2.from_angle(angle) * speed
