extends CheckBox


func _on_toggled(toggled_on: bool) -> void:
	(Settings.save as SaveData).pixel_perfect = toggled_on
	Settings.save_file()
	Hotkeys.set_scale_mode()
