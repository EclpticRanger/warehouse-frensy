extends Node2D

var spawn_positions: Array[Vector2] = [
	Vector2(-50, 550),
	Vector2(50, 550),
	Vector2(150, 550),
	Vector2(250, 550),
	Vector2(350, 550),
	
	Vector2(-50, 450),
	Vector2(50, 450),
	Vector2(150, 450),
	Vector2(250, 450),
	Vector2(350, 450),
	
	
	Vector2(-50, 250),
	Vector2(50, 250),
	Vector2(150, 250),
	Vector2(250, 250),
	Vector2(350, 250),
	
	Vector2(-50, 150),
	Vector2(50, 150),
	Vector2(150, 150),
	Vector2(250, 150),
	Vector2(350, 150),
	
	
	
	Vector2(800, 550),
	Vector2(900, 550),
	Vector2(1000, 550),
	Vector2(1100, 550),
	Vector2(1200, 550),
	
	Vector2(800, 450),
	Vector2(900, 450),
	Vector2(1000, 450),
	Vector2(1100, 450),
	Vector2(1200, 450),
	
	
	Vector2(800, 250),
	Vector2(900, 250),
	Vector2(1000, 250),
	Vector2(1100, 250),
	Vector2(1200, 250),
	
	Vector2(800, 150),
	Vector2(900, 150),
	Vector2(1000, 150),
	Vector2(1100, 150),
	Vector2(1200, 150),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signal_Bus.connect("spawn_box", spawn_box)

func spawn_box(id:int):
	var random_position = randi_range(0, len(spawn_positions)-1)
	
	var box_scene = load("res://Level/Food scene/box.tscn")
	var instance = box_scene.instantiate()
	instance.global_position = spawn_positions[random_position]
	instance.scale = Vector2(0.5, 0.5)
	instance.id = id
	add_child(instance)
