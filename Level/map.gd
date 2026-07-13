extends Node2D

var boxes_spawning: Array = []

func _ready() -> void:
	Globals.new_order()

func _on_new_order_timeout() -> void:
	Globals.new_order()
