extends Control

func _on_play_pressed() -> void:
	Globals.diferculty = $Container/VBoxContainer/VBoxContainer/OptionButton.selected
	get_tree().change_scene_to_file(Info.game_scene_file_path)


func _on_quit_pressed() -> void:
	get_tree().quit()
