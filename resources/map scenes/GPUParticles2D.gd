extends GPUParticles2D

const colors: Array[Color] = [Color("#ff00be"), Color("#00beff"),Color("#ff00be"), Color("#00beff"), Color("#beff00")]

func _ready() -> void:
	_on_finished()

func _on_finished() -> void:
	modulate = colors.pick_random()
	restart()
