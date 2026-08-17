extends StaticBody2D

var id: int
var player = null
var being_held: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = true
	$Area2D.monitorable = false
	hide()
	var box_texture: Texture = Globals.Box_db.Box_list.get(id).texture
	$Sprite2D.texture = box_texture
	$"Spawn Timer".wait_time = Globals.Box_db.Box_list.get(id).spawn_timer
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
	$Area2D.monitorable = true
	Signal_Bus.emit_signal("box_spawned", id)
	
func can_drop():
	if len($"place detection".get_overlapping_bodies()) > 0:
		return true
	else: return false
