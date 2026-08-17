extends Control

func _on_play_pressed() -> void:
	Globals.diferculty = $PanelContainer/VBoxContainer/VBoxContainer/OptionButton.selected
	get_tree().change_scene_to_file("res://Level/map.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_tutoral_pressed() -> void:
	Globals.tutoral = true
	Globals.tutoral_level = 1
	get_tree().change_scene_to_file("res://Tuttoral/Tutoral.tscn")
