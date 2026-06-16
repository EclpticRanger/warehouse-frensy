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

func _process(_delta: float) -> void:
	
	#In Game UI
	if $"in game ui".visible:
		money.text = "$" + str(int(round(Globals.money)))
		score.text = "Score " + str(Globals.score) 
	
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
						print(child)
						child.queue_free()
					i += 1
			i = 1
			for order in Globals.active_orders:
				var j = 0
				for ids in order:
					var add_child_path = get_node("Shop menu/Orders/ScrollContainer/HBoxContainer/" + str(i) + "/VBoxContainer/VBoxContainer")
					var item = load("res://Player/UI/ORDER SECTION.tscn")
					item = item.instantiate()
					item.get_node("ColorRect").texture = load(Info.Boxes_ids[ids][3])
					item.get_node("Label").text = Info.Boxes_ids[ids][1] + ": " + Globals.active_orders[i][j]
					get_node(add_child_path).add_child(item)
					j += 1
				i += 1

func on_fuel_changed(fuel):
	fuel_tank_bar.value = fuel[0]

func check_box_purchis(id: int):
	if Info.Boxes_ids[id][6] <= Globals.money:
		Globals.money -= Info.Boxes_ids[id][6]
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
