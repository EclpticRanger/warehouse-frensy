extends Node2D

var spawn_position = Vector2(594.0, 342.0)
var last_tutoral_index = 2

func _ready() -> void:
	change_scene(1)

func _on_change_tutoral_area_entered(area: Area2D) -> void:
	if Globals.tutoral_level == last_tutoral_index:
		Globals.tutoral = false
		Globals.tutoral_level = 0
		get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")
	else:
		Globals.tutoral_level += 1
		Globals.player.position = spawn_position
		change_scene(Globals.tutoral_level)



func change_scene(level : int):
	
	var scenes = [$"1", $"2"]
	for scene : Node2D in scenes:
		scene.hide()
		for child in scene.get_children():
			if child is TileMapLayer:
				child.collision_enabled = false
			if child is Area2D:
				child.monitorable = false
				child.monitoring = false
	
	get_child(level).show()
	for child in get_child(level).get_children():
			if child is TileMapLayer:
				child.collision_enabled = true
			if child is Area2D:
				child.monitorable = true
				child.monitoring = true
