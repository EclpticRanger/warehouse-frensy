extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signal_Bus.connect("spawn_box", spawn_box)

func spawn_box(id:int):
	var box_scene = load("res://Level/Food scene/box.tscn")
	var instance = box_scene.instantiate()
	instance.global_position = Vector2(575, 800)
	instance.scale = Vector2(0.5, 0.5)
	instance.id = id
	add_child(instance)
