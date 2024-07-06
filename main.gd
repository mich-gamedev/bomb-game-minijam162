extends Node2D


func _ready() -> void:
	EnemySpawner.reset()
	EnemySpawner.active = true
	Upgrades.reset()
