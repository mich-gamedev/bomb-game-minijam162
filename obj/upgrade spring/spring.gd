extends Area2D

@export var noise: FastNoiseLite

@onready var upgrade_ui: Control = $UpgradeUI
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var title: Label = %Title
@onready var desc: RichTextLabel = %Description
@onready var trans: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var spring_coll: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var timer: Timer = $Timer

var upgrade: UpgradePurchase

func _ready() -> void:
	noise.seed = randi()
	upgrade = Upgrades.possible_upgrades.pick_random() as UpgradePurchase
	title.text = upgrade.title
	desc.text = upgrade.description.to_upper().replace("[POS]", "[color=#beff00]").replace("[NEU]", "[color=#00beff]").replace("[NEG]", "[color=#ff00be]").replace("[/COLOR]", "[/color]")
	EnemySpawner.world_ended.connect(_on_world_ended)
	visible = false

func _physics_process(delta: float) -> void:
	spring_coll.disabled = !visible
	if visible:
		noise.offset.x += 5 * delta
		upgrade_ui.rotation_degrees = noise.get_noise_1d(0) * 5

func _on_world_ended() -> void:
	visible = true
	timer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player") and visible:
		anim.play(&"open")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player") and visible:
		anim.play(&"close")


func _on_hitbox_hurtbox_entered(hurtbox: Hurtbox) -> void:
	if visible:
		visible = false
		Upgrades.add_upgrade(upgrade)
		trans.play(&"close")
		await trans.animation_finished
		get_tree().reload_current_scene()
