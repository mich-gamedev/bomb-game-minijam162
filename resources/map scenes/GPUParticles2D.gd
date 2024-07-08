extends GPUParticles2D

const colors: Array[Color] = [Color("#ff00be"), Color("#00beff"),Color("#ff00be"), Color("#00beff"), Color("#beff00")]

func _process(delta: float) -> void:
	if !emitting:
		restart()
