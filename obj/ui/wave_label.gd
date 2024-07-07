extends RichTextLabel

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player_icon: TextureRect = %PlayerIcon
@onready var world_label: Label = %WorldLabel

func _ready() -> void:
	EnemySpawner.wave_just_started.connect(_flash_label)
	EnemySpawner.world_ended.connect(_on_world_ended)
	_on_world_ended()

func _process(delta: float) -> void:
	world_label.text = "WORLD:   %d \n HIGH SCORE:   %d" % [EnemySpawner.world, 0] #TODO: replace with high score

func _on_world_ended() -> void:
	world_label.text = "WORLD:   %d \n HIGH SCORE:   %d" % [EnemySpawner.world, 0] #TODO: replace with high score

func _flash_label() -> void:
	if EnemySpawner.wave <= 3:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(player_icon, "position:x", 90 + ((EnemySpawner.wave-1) * 16), 0.5)
	text = "WAVE %d" % EnemySpawner.wave
	anim.play(&"new_wave")
