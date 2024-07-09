extends CharacterBody2D

@export var speed: float
@export var accel: float
@export var friction: float
@export var jump_speed: float
@export var jump_gravity: float
@export var fall_gravity: float
@export var terminal_velocity: float
@export var knockback: float
@export var knockback_gravity: float

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_var_timer: Timer = $JumpVariationTimer
@onready var fire_bullet: FireBullet = $FireBullet
@onready var jump_particle: Sprite2D = $JumpParticle
@onready var jump_anim: AnimationPlayer = $JumpParticle/AnimationPlayer
@onready var label: Label = $Label
@onready var walk_particle: GPUParticles2D = $WalkParticle
@onready var hit_stutter: AnimationPlayer = $AnimatedSprite2D/HitStutter
@onready var health: Health = $Hitbox/Health
@onready var harm: GPUParticles2D = $Harm
@onready var heal: GPUParticles2D = $Heal
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var coll_shape: CollisionShape2D = $CollisionShape2D
@onready var walk_sfx: AnimationPlayer = $WalkSFX
@onready var land_stream: AudioStreamPlayer2D = $LandStream
@onready var slam_stream: AudioStreamPlayer2D = $SlamStream
@onready var spring_stream: AudioStreamPlayer2D = $SpringStream
@onready var death_stream: AudioStreamPlayer2D = $DeathStream
@onready var sparkle_stream: AudioStreamPlayer2D = $SparkleStream
@onready var hit_stream: AudioStreamPlayer2D = $HitStream

var hp: TextureRect

var landed: bool
var was_on_floor: bool
var attempting_jump: bool
var jump_combo: int = 0

var old_dir: float

signal jumped
signal direction_changed(old:float, new:float)

@onready var gravity: float = fall_gravity

var finished_level: bool
var knocked_back: bool

func _ready():
	hurtbox.damage = Upgrades.current.player_slam_damage
	terminal_velocity *= Upgrades.current.player_gravity
	jump_gravity *= Upgrades.current.player_gravity
	fall_gravity *= Upgrades.current.player_gravity
	health.invincibility_time = Upgrades.current.invincibility_time
	hp = get_tree().get_nodes_in_group("Health")[0] # healthbar
	health.health = PlayerStats.player_health
	hp.size.x = health.health * 9
	EnemySpawner.world_ended.connect(_on_world_ended)

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("left", "right") if health.health else 0.0
	if sign(dir):
		if !finished_level:
			walk_particle.emitting = is_on_floor() or velocity.y < 0
		velocity.x = move_toward(velocity.x, speed * dir * Upgrades.current.player_speed, accel * delta)
		if is_on_floor():
			walk_sfx.play(&"walk")
			jump_combo = 0
			if !knocked_back:
				sprite.play(&"walk")
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if is_on_floor() and !knocked_back:
			walk_sfx.play(&"RESET")
			sprite.play(&"idle")
	if dir != old_dir:
		direction_changed.emit(old_dir, dir)
		old_dir = dir
		if dir:
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(sprite, "scale:x", sign(dir), 0.15)

	if Input.is_action_just_pressed("jump"):
		attempting_jump = true
		buffer_timer.start()
	if Input.is_action_just_released("jump"):
		gravity = fall_gravity
		if !knocked_back:
			walk_sfx.play(&"RESET")
			sprite.play(&"fall")
	if is_on_floor():
		was_on_floor = true
	elif was_on_floor: coyote_timer.start()
	if attempting_jump and was_on_floor:
		velocity.y = -jump_speed * Upgrades.current.player_jump
		jumped.emit()
		walk_sfx.play(&"RESET")
		sprite.play(&"jump")
		attempting_jump = false
		was_on_floor = false
		jump_var_timer.start()
		fire_bullet.damage = Upgrades.current.bomb_damage
		fire_bullet.speed = 160 * Upgrades.current.bomb_speed
		fire_bullet.projectile_count = Upgrades.current.bomb_count
		fire_bullet.projectile_range = deg_to_rad(Upgrades.current.bomb_spread)
		var bullets = fire_bullet.fire(velocity.angle())
		for i in bullets:
			i.scale = Vector2.ONE + (((Upgrades.current.explosion_radius - 1.0) / 2.0) * Vector2.ONE)
		if Input.is_action_pressed("jump"):
			gravity = jump_gravity

	if !landed and is_on_floor():
		landed = true
		land_stream.play()
	elif !is_on_floor():
		landed = false

	if knocked_back:
		gravity = knockback_gravity
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	if finished_level:
		walk_particle.emitting = true
		walk_particle.amount = 48

	if health.can_harm: hit_stutter.play(&"RESET")
	else: hit_stutter.play(&"harmed")

	move_and_slide()

func _on_buffer_timer_timeout() -> void:
	attempting_jump = false
func _on_coyote_timer_timeout() -> void:
	was_on_floor = false
func _on_jump_variation_timer_timeout() -> void:
	if !knocked_back:
		sprite.play(&"fall")
	gravity = fall_gravity


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player_bomb") and body.velocity.y > 0 and velocity.y < 0:
		body.velocity.y = -body.velocity.y
		body.velocity.x += velocity.x


func _on_hurtbox_hitbox_entered(hitbox: Hitbox) -> void:
	if velocity.y < 0: return
	slam_stream.play()
	jump_combo += 1
	label.text = "%dx" % jump_combo
	label.global_position = global_position + Vector2(2,3)
	velocity.y = -jump_speed * Upgrades.current.player_jump
	knocked_back = false
	if hitbox.is_in_group(&"end_spring") and !(hitbox.owner.timer.time_left) and !hitbox.owner.settings and !hitbox.owner.exit:
		spring_stream.play()
		sparkle_stream.play()
		coll_shape.set_deferred("disabled", true)
		PlayerStats.player_health = health.health
		velocity.y = 0
		jump_gravity = -560
		fall_gravity = -560
		gravity = fall_gravity
		finished_level = true
	jump_anim.stop()
	jump_particle.global_position = global_position
	jump_particle.rotation = velocity.angle() + (PI/2)
	jump_anim.play(&"hit")
	sprite.play(&"jump")
	hitbox.player_stomped.emit(self)


func _on_hitbox_hurtbox_entered(hurtbox):
	knocked_back = true
	var vec = Vector2((global_position - hurtbox.global_position) + (Vector2.UP * 6)).normalized() * knockback
	velocity = vec
	sprite.play(&"hitflash")
	await sprite.animation_finished
	sprite.play(&"kb")
	await get_tree().create_timer(0.33).timeout
	knocked_back = false


func _on_health_changed(amount):
	print(health.health)
	hp.scale.y = 2
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(hp, "size:x", health.health * 9, 0.25)
	tween.parallel().tween_property(hp, "scale:y", 1, 1).set_trans(Tween.TRANS_ELASTIC)

func _on_world_ended() -> void:
	health.heal([1,1,1,1,1,1,2,2,3].pick_random())


func _on_health_harmed(amount: float) -> void:
	hit_stream.play()
	harm.amount = amount
	harm.restart()


func _on_health_healed(amount: float) -> void:
	heal.amount = amount
	heal.restart()


func _on_health_died() -> void:
	coll_shape.set_deferred("disabled", true)
	death_stream.play()
	velocity.y = -jump_speed
	velocity.x /= 1.5
	friction = 0.0
	knockback_gravity = 480
	PlayerStats.player_died.emit()
	PlayerStats.player_health = 5.0

