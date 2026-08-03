extends Control

func _on_play_pressed() -> void:
	Globals.diferculty = $PanelContainer/VBoxContainer/VBoxContainer/OptionButton.selected
	get_tree().change_scene_to_file("res://Level/map.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
