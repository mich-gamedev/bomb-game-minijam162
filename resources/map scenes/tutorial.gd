extends Node2D

@onready var cam: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	EnemySpawner.active = false
	Upgrades.reset()
	EnemySpawner.reset()


func _process(delta: float) -> void:
	if player.position.x < 224:
		cam.position = Vector2.ZERO
	else:
		cam.position = Vector2(224,0)
