extends RichTextLabel

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player_icon: TextureRect = %PlayerIcon

func _ready() -> void:
	EnemySpawner.wave_just_started.connect(_flash_label)

func _flash_label() -> void:
	if EnemySpawner.wave <= 3:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(player_icon, "position:x", 90 + ((EnemySpawner.wave-1) * 16), 0.5)
	text = "WAVE %d" % EnemySpawner.wave
	anim.play(&"new_wave")
