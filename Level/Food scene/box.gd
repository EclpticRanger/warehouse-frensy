extends StaticBody2D
class_name box

var id: int
var player = null
var being_held: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = true
	hide()
	var box_texture: Texture = load(Info.Boxes_ids[id][3])
	$Sprite2D.texture = box_texture
	$"Spawn Timer".wait_time = Info.Boxes_ids[id][8]
	$"Spawn Timer".start()
	Signal_Bus.i_a_box_spawned.emit(self, $"Spawn Timer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if being_held and player != null:
		position = player.position
		rotation = player.rotation
		$CollisionShape2D.disabled = true
	else: $CollisionShape2D.disabled = false


func _on_spawn_timer_timeout() -> void:
	show()
	$CollisionShape2D.disabled = false
	Signal_Bus.emit_signal("box_spawned", id)
