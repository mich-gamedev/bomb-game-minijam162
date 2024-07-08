extends HSlider


func _on_value_changed(value: float) -> void:
	(Settings.save as SaveData).music_volume = value
	Settings.save_file()
