extends Area2D

var id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	id = get_parent().id
