extends StaticBody2D
class_name box

var player = null
var being_held: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if being_held and player != null:
		position = player.position
		rotation = player.rotation
		$CollisionShape2D.disabled = true
	else: $CollisionShape2D.disabled = false
