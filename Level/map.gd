extends Node2D

var boxes_spawning: Array = []

func _ready() -> void:
	Signal_Bus.new_order.connect(start_timer)
	Globals.new_order()

func _on_new_order_timeout() -> void:
	Globals.new_order()

func _on_order_timeout(extra_arg_0: int) -> void:
	Globals.order_timeout(extra_arg_0)

func _physics_process(delta: float) -> void:
	if $"Orders/Timers/Order 1".paused:
		Globals.order1_timer = -1
	else: Globals.order1_timer = $"Orders/Timers/Order 1".time_left
	#print(Globals.order1_timer)
	
	if $"Orders/Timers/Order 2".paused:
		Globals.order2_timer = -1
	else: Globals.order2_timer = $"Orders/Timers/Order 2".time_left
	
	if $"Orders/Timers/Order 3".paused:
		Globals.order3_timer = -1
	else: Globals.order3_timer = $"Orders/Timers/Order 3".time_left
	
	if $"Orders/Timers/Order 4".paused:
		Globals.order4_timer = -1
	else: Globals.order4_timer = $"Orders/Timers/Order 4".time_left
	
	if $"Orders/Timers/Order 5".paused:
		Globals.order5_timer = -1
	else: Globals.order5_timer = $"Orders/Timers/Order 5".time_left

func start_timer(id: int):
	var timer : Timer = $Orders/Timers.get_child(id -1)
	timer.wait_time = 150 / Globals.diffculty_mutiplyer
	timer.start()
	print("start")
