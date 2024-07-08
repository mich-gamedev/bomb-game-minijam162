extends Node2D

@onready var cam: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var high_score_sign: Area2D = $HighScoreSign

func _ready() -> void:
	EnemySpawner.active = false
	Upgrades.reset()
	EnemySpawner.reset()


func _process(delta: float) -> void:
	high_score_sign.sign_text = "HIGH SCORE.........\n%d\n\nJUMP ON SPRING\nTO PLAY" % Settings.save.high_score
	if player.position.x < 224:
		cam.position = Vector2.ZERO
	else:
		cam.position = Vector2(224,0)
