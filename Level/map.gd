extends Node2D

var boxes_spawning: Array = []


func _on_new_order_timeout() -> void:
	Info.new_order()
