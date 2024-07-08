extends VBoxContainer


func _on_back_button_pressed() -> void:
	Settings.unpause()

func _on_main_menu_pressed() -> void:
	get_tree().reload_current_scene.call_deferred()
	Settings.unpause()

func _on_leave_pressed() -> void:
	get_tree().quit()
