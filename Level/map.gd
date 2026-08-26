extends Node2D

var boxes_spawning: Array = []

func _ready() -> void:
	Signal_Bus.new_order.connect(start_timer)
	Globals.new_order()

func _on_new_order_timeout() -> void:
	Globals.new_order()

func _on_order_timeout(extra_arg_0: int) -> void:
	Globals.order_timeout(extra_arg_0)

func _physics_process(_delta: float) -> void:
	for order: Order in Globals.active_orders:
		var timer : Timer = $Orders/Timers.get_child(order.id - 1)
		order.timer = timer.time_left

func start_timer(id: int):
	var timer : Timer = $Orders/Timers.get_child(id -1)
	timer.wait_time = round(150.0 / Globals.diffculty_mutiplyer)
	timer.start()
