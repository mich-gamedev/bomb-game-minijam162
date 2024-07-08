extends CanvasLayer

var save: SaveData

@onready var particle_button: CheckBox = %ParticleButton
@onready var pixel_button: CheckBox = %PixelButton
@onready var sfx_slider: HSlider = %SFXslider
@onready var music_slider: HSlider = %MusicSlider

const file_path : String = "user://save_data.tres"

func save_file() -> void:
	ResourceSaver.save(save, file_path)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), linear_to_db(save.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Audio"), linear_to_db(save.sfx_volume))

func load_file() -> void:
	if ResourceLoader.exists(file_path):
		save = load(file_path)
	else:
		save = SaveData.new()
		save_file()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), linear_to_db(save.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Audio"), linear_to_db(save.sfx_volume))


func _ready() -> void:
	load_file()
	unpause()

func unpause() -> void:
	hide()
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(&"Music"), 0, false)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(&"Music"), 1, false)

func pause() -> void:
	show()
	get_tree().paused = true
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(&"Music"), 0, true)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(&"Music"), 1, true)
