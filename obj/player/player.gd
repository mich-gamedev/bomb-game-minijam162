extends CharacterBody2D

@export var speed: float
@export var accel: float
@export var friction: float
@export var jump_speed: float
@export var jump_gravity: float
@export var fall_gravity: float
@export var terminal_velocity: float

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_var_timer: Timer = $JumpVariationTimer
@onready var fire_bullet: FireBullet = $FireBullet
@onready var jump_particle: Sprite2D = $JumpParticle
@onready var jump_anim: AnimationPlayer = $JumpParticle/AnimationPlayer
@onready var label: Label = $Label
@onready var walk_particle: GPUParticles2D = $WalkParticle

var was_on_floor: bool
var attempting_jump: bool
var jump_combo: int = 0

var old_dir: float

signal jumped
signal direction_changed(old:float, new:float)

@onready var gravity: float = fall_gravity

var finished_level: bool


func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("left", "right")
	if sign(dir):
		if !finished_level:
			walk_particle.emitting = is_on_floor() or velocity.y < 0
		velocity.x = move_toward(velocity.x, speed * dir * Upgrades.current.player_speed, accel * delta)
		if is_on_floor():
			jump_combo = 0
			sprite.play(&"walk")
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if is_on_floor():
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
		sprite.play(&"fall")
	if is_on_floor(): was_on_floor = true
	elif was_on_floor: coyote_timer.start()
	if attempting_jump and was_on_floor:
		velocity.y = -jump_speed * Upgrades.current.player_jump
		jumped.emit()
		sprite.play(&"jump")
		attempting_jump = false
		was_on_floor = false
		jump_var_timer.start()
		fire_bullet.damage = Upgrades.current.bomb_damage
		fire_bullet.speed = 160 * Upgrades.current.bomb_speed
		fire_bullet.projectile_count = Upgrades.current.bomb_count
		fire_bullet.fire(velocity.angle())
		if Input.is_action_pressed("jump"):
			gravity = jump_gravity

	velocity.y = move_toward(velocity.y, terminal_velocity * Upgrades.current.player_gravity, gravity * delta)
	if finished_level:
		walk_particle.emitting = true
		walk_particle.amount = 48
	move_and_slide()

func _on_buffer_timer_timeout() -> void:
	attempting_jump = false
func _on_coyote_timer_timeout() -> void:
	was_on_floor = false
func _on_jump_variation_timer_timeout() -> void:
	sprite.play(&"fall")
	gravity = fall_gravity


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player_bomb") and body.velocity.y > 0 and velocity.y < 0:
		body.velocity.y = -body.velocity.y
		body.velocity.x += velocity.x


func _on_hurtbox_hitbox_entered(hitbox: Hitbox) -> void:
	jump_combo += 1
	label.text = "%dx" % jump_combo
	label.global_position = global_position + Vector2(2,3)
	velocity.y = -jump_speed * Upgrades.current.player_jump
	if hitbox.is_in_group(&"end_spring"):
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
