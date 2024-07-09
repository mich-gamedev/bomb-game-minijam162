extends CharacterBody2D

@onready var fire_bullet: FireBullet = $FireBullet
@onready var particle: GPUParticles2D = $GPUParticles2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_bullet: FireBullet = $FireBullet2


func _ready() -> void:
	fire_bullet.projectile_count -= 1
	_on_timer_timeout()

func _physics_process(delta: float) -> void:
	sprite.flip_h = velocity.x > 0

func _on_timer_timeout() -> void:
	particle.restart()
	await get_tree().create_timer(1.5).timeout
	var player = get_tree().get_first_node_in_group(&"player")
	if is_instance_valid(player):
		fire_bullet.fire(global_position.angle_to_point(player.global_position) + randf_range(-PI/8, PI/8))
	particle.emitting = false


func _on_health_died() -> void:
	(sprite.material as ShaderMaterial).set_shader_parameter("distortion", 0.1)
	particle.restart()
	await get_tree().create_timer(1.0).timeout
	death_bullet.fire(randf_range(0, TAU))
