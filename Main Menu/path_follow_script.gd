extends PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random = randi_range(1, Globals.Box_db.Box_list.size()-1)
	$Sprite2D/Sprite2D.texture = Globals.Box_db.Box_list.get(random).texture
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress_ratio == 1:
		var random = randi_range(1, Globals.Box_db.Box_list.size()-1)
		$Sprite2D/Sprite2D.texture = Globals.Box_db.Box_list.get(random).texture
		progress = 0
	progress += delta * 250
