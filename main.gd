extends Node2D

const maps : Array[PackedScene] = [
	preload("res://resources/map scenes/1.tscn"),
	preload("res://resources/map scenes/0.tscn"),
]

var inst: Node2D

func _ready() -> void:
	reload()

func reload() -> void:
	if inst != null:
		inst.queue_free()
	inst = maps.pick_random().instantiate()
	add_child(inst)
	EnemySpawner.wave = 0
	EnemySpawner.active = true
	EnemySpawner.wave_started = false
