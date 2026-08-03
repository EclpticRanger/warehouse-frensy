extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('box'):
		Globals.remove_box_from_orders(area.id)
		Globals.score += Globals.Box_db.Box_list.get(area.id).sell_price
		Globals.money += Globals.Box_db.Box_list.get(area.id).sell_price
		area.get_parent().queue_free()
		
		Globals.player.is_holding = false
		Globals.player.holing = null
