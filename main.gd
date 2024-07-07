extends Node2D

const maps : Array[PackedScene] = [
	preload("res://resources/map scenes/1.tscn"),
	preload("res://resources/map scenes/0.tscn"),
	preload("res://resources/map scenes/2.tscn"),
	preload("res://resources/map scenes/3.tscn"),
	preload("res://resources/map scenes/4.tscn"),
]

@onready var animation_player: AnimationPlayer = $CanvasLayer3/AnimationPlayer
var tutorial_map = preload("res://resources/map scenes/tutorial.tscn")
var inst: Node2D

@onready var UI = $CanvasLayer2

func _ready() -> void:
	tutorial()
	PlayerStats.player_died.connect(_on_player_died)

func tutorial() -> void:
	EnemySpawner.world_ended.emit()
	UI.visible = false
	inst = tutorial_map.instantiate()
	add_child(inst)

func reload() -> void:
	UI.visible = true
	if inst != null:
		inst.queue_free()
	inst = maps.pick_random().instantiate()
	add_child(inst)
	EnemySpawner.wave = 0
	EnemySpawner.active = true
	EnemySpawner.wave_started = false

func _on_player_died() -> void:
	animation_player.play(&"end")
	await animation_player.animation_finished
	tutorial()
	#TODO: send user to main menu on death
