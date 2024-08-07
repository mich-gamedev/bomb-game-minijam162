extends Area2D


@onready var upgrade_ui: Control = $UpgradeUI
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var title: Label = %Title
@onready var desc: RichTextLabel = %Description
@onready var trans: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var spring_coll: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var timer: Timer = $Timer
@onready var left_side_screen: VisibleOnScreenNotifier2D = $UpgradeUI/PanelContainer/Control2/LeftSideScreen
@onready var right_side_screen: VisibleOnScreenNotifier2D = $UpgradeUI/PanelContainer/Control/RightSideScreen
@onready var panel_container: PanelContainer = $UpgradeUI/PanelContainer
@onready var node_pooler: NodePooler = $NodePooler

var upgrade: UpgradePurchase
@export var always_active: bool = false
@export var settings: bool = false
@export var exit: bool = false

func _ready() -> void:
	upgrade = Upgrades.possible_upgrades.pick_random() as UpgradePurchase
	title.text = upgrade.title
	desc.text = upgrade.description.to_upper().replace("[POS]", "[color=#beff00]").replace("[NEU]", "[color=#00beff]").replace("[NEG]", "[color=#ff00be]").replace("[/COLOR]", "[/color]")
	EnemySpawner.world_ended.connect(_on_world_ended)
	visible = false
	if always_active:
		_on_world_ended()

func _physics_process(delta: float) -> void:
	spring_coll.disabled = timer.time_left or !(visible)
	if !left_side_screen.is_on_screen(): panel_container.position.x += 8
	if !right_side_screen.is_on_screen(): panel_container.position.x -= 8

func _on_world_ended() -> void:
	var inst = node_pooler.grab_available_object()
	inst.global_position = global_position
	visible = true
	if get_overlapping_bodies().any(func(a: Node): return a.is_in_group(&"player")):
		anim.play(&"open")
		timer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player") and visible and !always_active:
		anim.play(&"open")
		timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player") and visible and !always_active:
		anim.play(&"close")


func _on_hitbox_player_stomped(player: CharacterBody2D) -> void:
	if visible and !timer.time_left:
		if !always_active:
			Upgrades.add_upgrade(upgrade)
			visible = false
		if settings:
			Settings.pause()
			visible = false
		if exit:
			get_tree().quit()
		if !settings and !exit:
			trans.play(&"close")
			await trans.animation_finished
			get_tree().current_scene.reload()
		if settings:
			while !player.is_on_floor():
				await get_tree().physics_frame
			visible = true
