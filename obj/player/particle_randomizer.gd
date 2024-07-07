extends GPUParticles2D

const colors: Array[Color] = [Color("#ff00be"), Color("#00beff"), Color("#beff00")]

func _ready() -> void:
	modulate = colors.pick_random()
