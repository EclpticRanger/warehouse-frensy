extends Control

@export var fuel_tank_nodepath: TextureProgressBar
@export var shop_menu_nodepath: Control
@export var shop_menu_money_nodepath: Label
@export var order_menu_nodepath: Control
@export var in_ui_nodepath: Control
@export var score_nodepath: Label
@export var money_nodepath: Label

@onready var fuel_tank_bar = fuel_tank_nodepath
@onready var shop_menu = shop_menu_nodepath
@onready var shop_menu_money = shop_menu_money_nodepath
@onready var order_menu = order_menu_nodepath
@onready var in_game_ui = in_ui_nodepath
@onready var money = money_nodepath
@onready var score = score_nodepath

func _ready() -> void:
	Signal_Bus.change_fuel.connect(on_fuel_changed)

func _process(_delta: float) -> void:
	money.text = "$" + str(Globals.money)
	shop_menu_money.text = "$" + str(Globals.money)
	score.text = "Score " + str(Globals.score) 
	

func on_fuel_changed(fuel):
	fuel_tank_bar = fuel

func try_open_or_close_ui(ui_id):
	#Key: 1 = in game ui
#     2 = shop ui
#     3 = orders ui
	in_game_ui.hide()
	order_menu.hide()
	shop_menu.hide()
	if ui_id == 2 and Globals.ui_in == 1:
		shop_menu.show()
		Globals.ui_in = 2
	elif ui_id == 2 and Globals.ui_in == 3:
		shop_menu.show()
		Globals.ui_in = 2
	elif ui_id == 3 and Globals.ui_in == 1:
		Globals.ui_in = 3
		order_menu.show()
	elif ui_id == 3 and Globals.ui_in == 2:
		Globals.ui_in = 3
		order_menu.show()
	elif ui_id == 2 and Globals.ui_in == 2:
		in_game_ui.show()
		Globals.ui_in = 1
	elif ui_id == 3 and Globals.ui_in == 3:
		in_game_ui.show()
		Globals.ui_in = 1


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
