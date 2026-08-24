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

func _ready() -> void:
	Deleverys_h_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	Signal_Bus.change_fuel.connect(on_fuel_changed)
	Signal_Bus.box_spawned.connect(on_box_spawned)
	
	$"Shop menu".hide()
	$"in game ui".show()
	$"Shop menu/Shop".show()
	$"Shop menu/Shop/GridContainer/Control/ColorRect".texture = Globals.Box_db.Box_list.get(0).texture
	$"Shop menu/Shop/GridContainer/Control/Label".text = Globals.Box_db.Box_list.get(0).name
	$"Shop menu/Shop/GridContainer/Control/Label2".text = "Price: " + str(Globals.Box_db.Box_list.get(0).price)
	
	$"Shop menu/Shop/GridContainer/Control2/ColorRect".texture = Globals.Box_db.Box_list.get(1).texture
	$"Shop menu/Shop/GridContainer/Control2/Label".text = Globals.Box_db.Box_list.get(1).name
	$"Shop menu/Shop/GridContainer/Control2/Label2".text = "Price: " + str(Globals.Box_db.Box_list.get(1).price)
	
	$"Shop menu/Shop/GridContainer/Control3/ColorRect".texture = Globals.Box_db.Box_list.get(2).texture
	$"Shop menu/Shop/GridContainer/Control3/Label".text = Globals.Box_db.Box_list.get(2).name
	$"Shop menu/Shop/GridContainer/Control3/Label2".text = "Price: " + str(Globals.Box_db.Box_list.get(2).price)
	
	if Globals.tutoral:
		$"in game ui/Fuel Tank".hide()
		$"in game ui/Money".hide()
		$"in game ui/Score".hide()
		$"in game ui/Sprite2D".hide()
	

func _process(_delta: float) -> void:
	
	for order : Order in Globals.active_orders:
		pass
	
	
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
			var i = 1
			for orderID in $"Shop menu/Orders/ScrollContainer/HBoxContainer".get_children():
				if get_node("Shop menu/Orders/ScrollContainer/HBoxContainer/%s/VBoxContainer/VBoxContainer" % i):
					for child in get_node("Shop menu/Orders/ScrollContainer/HBoxContainer/%s/VBoxContainer/VBoxContainer" % i).get_children():
						child.queue_free()
					i += 1
			i = 0
			for order : Order in Globals.active_orders:
				var order_quantitys_fixed = order.quantitys
				for k in range(order.quantitys.size()):
					if order_quantitys_fixed[k] == 0: continue
					var add_child_path = get_node("Shop menu/Orders/ScrollContainer/HBoxContainer/" + str(i + 1) + "/VBoxContainer/VBoxContainer")
					var item = load("res://Player/UI/ORDER SECTION.tscn")
					item = item.instantiate()
					item.get_node("ColorRect").texture = Globals.Box_db.Box_list.get(k).texture
					item.get_node("Label").text = Globals.Box_db.Box_list.get(k).name + ": " + str(order_quantitys_fixed[k])
					add_child_path.add_child(item)
				i += 1
			
			$"Shop menu/Orders/ScrollContainer/HBoxContainer/1/VBoxContainer/time".text = str(int(Globals.order1_timer))
			$"Shop menu/Orders/ScrollContainer/HBoxContainer/2/VBoxContainer/time".text = str(int(Globals.order2_timer))
			$"Shop menu/Orders/ScrollContainer/HBoxContainer/3/VBoxContainer/time".text = str(int(Globals.order3_timer))
			$"Shop menu/Orders/ScrollContainer/HBoxContainer/4/VBoxContainer/time".text = str(int(Globals.order4_timer))
			$"Shop menu/Orders/ScrollContainer/HBoxContainer/5/VBoxContainer/time".text = str(int(Globals.order5_timer))

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
		Signal_Bus.emit_signal("spawn_box", button)
		Globals.food_purchsed += 1

func on_box_spawned(id: int):
	pass
	#this will be used for the Dellivering menu

func _on_retire_button_preesed() -> void:
	Globals.reset_values()
	get_tree().change_scene_to_file("res://Main Menu/Main Menu.tscn")
