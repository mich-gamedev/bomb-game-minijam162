extends Node2D

const maps : Array[PackedScene] = [
	preload("res://resources/map scenes/0.tscn"),
]

func _ready() -> void:
	var inst : Node2D = maps.pick_random().instantiate()
	add_child(inst)
	EnemySpawner.wave = 0
	EnemySpawner.active = true
	EnemySpawner.wave_started = false
