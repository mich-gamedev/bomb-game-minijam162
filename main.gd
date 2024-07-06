extends Node2D


func _ready() -> void:
	EnemySpawner.wave = 0
	EnemySpawner.active = true
	EnemySpawner.wave_started = false
