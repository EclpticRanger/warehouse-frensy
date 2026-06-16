extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Pickapable"):
		body.queue_free()
		Globals.remove_box_from_orders(body.id)
		Globals.score += Info.Boxes_ids[body.id][7]
		Globals.money += Info.Boxes_ids[body.id][7]
