extends CheckBox


func _on_toggled(toggled_on: bool) -> void:
	(Settings.save as SaveData).enable_particles = toggled_on
	Settings.save_file()
