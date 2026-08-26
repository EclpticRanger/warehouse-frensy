extends Control

var Deleverys_h_box: HBoxContainer = HBoxContainer.new()

@export var fuel_tank_nodepath: TextureProgressBar
@export var shop_menu_nodepath: TabContainer
@export var shop_menu_money_nodepath: Label
@export var in_ui_nodepath: Control
@export var score_nodepath: Label
@export var money_nodepath: Label

@onready var fuel_tank_bar = fuel_tank_nodepath
@onready var shop_menu = shop_menu_nodepath
@onready var shop_menu_money = shop_menu_money_nodepath
@onready var in_game_ui = in_ui_nodepath
@onready var money = money_nodepath
@onready var score = score_nodepath

var Delivering_items = []
var j = 0

func _ready() -> void:
	Deleverys_h_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	Signal_Bus.change_fuel.connect(on_fuel_changed)
	Signal_Bus.box_spawned.connect(on_box_spawned)
	
	$"Shop menu".hide()
	$"in game ui".show()
	$"Shop menu/Shop".show()
	
	for i in range(Globals.Box_db.Box_list.size()):
		get_node("Shop menu/Shop/GridContainer/Control" + str(i + 1) + "/ColorRect").texture = Globals.Box_db.Box_list.get(i).texture
		get_node("Shop menu/Shop/GridContainer/Control" + str(i + 1) + "/Label").text = Globals.Box_db.Box_list.get(i).name
		get_node("Shop menu/Shop/GridContainer/Control" + str(i + 1) + "/Label2").text = "Price: " + str(Globals.Box_db.Box_list.get(i).price)
		get_node("Shop menu/Shop/GridContainer/Control" + str(i + 1) + "/Label3").text = "Sell Price: " + str(Globals.Box_db.Box_list.get(i).sell_price)
	
	if Globals.tutoral:
		$"in game ui/Fuel Tank".hide()
		$"in game ui/Money".hide()
		$"in game ui/Score".hide()
		$"in game ui/Sprite2D".hide()

func _physics_process(delta: float) -> void:
	j += 1

func _process(_delta: float) -> void:
	
	
	#In Game UI
	if $"in game ui".visible:
		money.text = "$" + str(int(round(Globals.money)))
		score.text = "Score " + str(Globals.score)
		$"in game ui/Control/Maker".set_position(Vector2(Globals.reputation * 2.273, -2))
		if Globals.reputation >= 100:
			Globals.reputation = 100
		if Globals.reputation <= 0:
			Globals.reputation = 0
	
	#Shop Menu
	elif $"Shop menu".visible:
		
		#Retire Menue
		if $"Shop menu/Retire".visible:
			$"Shop menu/Retire/CenterContainer/VBoxContainer/Money".text = "Money: %s" % int(round(Globals.money))
			$"Shop menu/Retire/CenterContainer/VBoxContainer/Score".text = "Score: %s" % Globals.score
			$"Shop menu/Retire/CenterContainer/VBoxContainer/Active Orders".text = "Active Orders: %s" % len(Globals.active_orders)
			$"Shop menu/Retire/CenterContainer/VBoxContainer/Orders Fullfuled".text = "Orders Fulled: %s" % Globals.orders_fulled
		
		#Shop
		if $"Shop menu/Shop".visible:
			shop_menu_money.text = "$" + str(int(round(Globals.money)))
			
		
		#Orders Menu
		if $"Shop menu/Orders".visible:
			
			if j % 20 == 0:
				rebuild_orders_ui()
			
			var index = 0
			for order: Order in Globals.active_orders:
				# Use index + 1 instead of order.id + 1 to match how they were built in the UI
				var time_label = get_node_or_null("Shop menu/Orders/ScrollContainer/HBoxContainer/" + str(index + 1) + "/VBoxContainer/time")
				if time_label != null:
					time_label.text = str(int(order.timer))
				index += 1
			
func rebuild_orders_ui():
	var i = 1
	# Clear out the old UI
	for order_node in $"Shop menu/Orders/ScrollContainer/HBoxContainer".get_children():
		var item_container = get_node_or_null("Shop menu/Orders/ScrollContainer/HBoxContainer/%s/VBoxContainer/VBoxContainer" % i)
		if item_container:
			for child in item_container.get_children():
				child.queue_free()
		i += 1
		
	# Rebuild the UI based on active orders
	i = 0
	for order: Order in Globals.active_orders:
		var sorted_quantity_keys = order.quantitys.keys()
		sorted_quantity_keys.sort() 
		
		for key in sorted_quantity_keys:
			var value = order.quantitys[key]
			if value == 0: continue
			
			var add_child_path = get_node("Shop menu/Orders/ScrollContainer/HBoxContainer/" + str(i + 1) + "/VBoxContainer/VBoxContainer")
			var item = load("res://Player/UI/ORDER SECTION.tscn").instantiate()
			
			item.get_node("ColorRect").texture = Globals.Box_db.Box_list.get(key).texture
			item.get_node("Label").text = Globals.Box_db.Box_list.get(key).name + ": " + str(value)
			add_child_path.add_child(item)
		i += 1

func on_fuel_changed(fuel):
	fuel_tank_bar.value = fuel[0]

func check_box_purchis(id: int):
	if Globals.Box_db.Box_list.get(id).price <= Globals.money:
		Globals.money -= Globals.Box_db.Box_list.get(id).price
		return true
	else: 
		print("Out of money")
		return false

func _on__pressed(button: int) -> void:
	if check_box_purchis(button):
		Signal_Bus.emit_signal("spawn_box", button - 1)
		Globals.food_purchsed += 1

func on_box_spawned(id: int):
	pass
	#this will be used for the Dellivering menu

func _on_retire_button_preesed() -> void:
	Globals.reset_values()
	get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")
