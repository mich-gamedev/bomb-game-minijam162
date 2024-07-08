extends Node

var old_window_mode: int

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		set_fullscreen()
	if Input.is_action_just_pressed("pause"):
		Settings.pause()

func set_fullscreen():
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		old_window_mode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(old_window_mode)

func set_scale_mode():
		if Settings.save.pixel_perfect == false:
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		else:
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
