extends StaticBody2D
class_name tutoral_box

@export var id: int

var player = null
var being_held: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if being_held and player != null:
		position = player.position
		rotation = player.rotation
		$CollisionShape2D.disabled = true
	else: $CollisionShape2D.disabled = false

func can_drop():
	if len($"place detection".get_overlapping_bodies()) > 0:
		return true
	else: return false
