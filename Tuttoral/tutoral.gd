extends Node2D

var spawn_position = Vector2(594.0, 342.0)
var last_tutoral_index = 4

func _ready() -> void:
	change_scene(1)
	Signal_Bus.connect("spawn_box", spawn_box)

func spawn_box(id:int):
	var box_scene = load("res://Level/Food scene/box.tscn")
	var instance = box_scene.instantiate()
	instance.global_position = Vector2(300, 300)
	instance.scale = Vector2(0.5, 0.5)
	instance.id = id
	add_child(instance)

func _on_change_tutoral_area_entered(area: Area2D) -> void:
	if Globals.tutoral_level == 3:
		remove_child($Player)
	Globals.tutoral_level += 1
	Globals.player.position = spawn_position
	change_scene(Globals.tutoral_level)

func change_scene(level : int):
	
	var scenes = [$"1", $"2", $"3", $"4"]
	for scene : Node2D in scenes:
		scene.hide()
		for child in scene.get_children():
			if child is TileMapLayer:
				child.collision_enabled = false
			if child is Area2D:
				child.monitorable = false
				child.monitoring = false
	
	get_node(str(Globals.tutoral_level)).show()
	for child in get_child(level).get_children():
			if child is TileMapLayer:
				child.collision_enabled = true
			if child is Area2D:
				child.monitorable = true
				child.monitoring = true


func _on_button_pressed() -> void:
	Globals.tutoral = false
	Globals.tutoral_level = 0
	Globals.new_order()
	get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")
