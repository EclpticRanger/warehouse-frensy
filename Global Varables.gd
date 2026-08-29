extends Node



var Box_db: box_database = load("res://Resorses/Data/db.tres")
var db_order_name : Order_names = load("res://Resorses/Data/names.tres")
var player : CharacterBody2D

var score : int = 0
#Difficulty
#1 = Easy
#2 = Normal
#3 = Hard
#4 = Arsonist
var diferculty : int = 1

var food_purchsed: int = 0
var money : float = 200

var active_orders: Array = []
var orders_fulled: int = 0

var game_scene_file_path : String = "res://Level/map.tscn"

var tutoral: bool = false
var tutoral_level: int = 0

var score_scale_multerplyer_scaling: float = 0.01
var score_scale_multaplyer: float = 1
var defult_mass: float = 40
var total_weight = 0
var diffculty_mutiplyer = 1
var masses = []
var weights = []
var reputation : float = 0


func _ready() -> void:
	for i in range(Box_db.Box_list.size()):
		total_weight += Box_db.Box_list.get(i).weight
		weights.append(Box_db.Box_list.get(i).weight)
	

func reset_values():
	score = 0
	diferculty = 2
	food_purchsed = 0
	money = 200
	active_orders = []
	orders_fulled = 0
	reputation = 0

func clear_fuffled_order():
	for order in Globals.active_orders:
		for id in order.quantitys:
			if order.quantitys[id] <= 0:
				order.quantitys.erase(id)
		if order.quantitys == {}:
			active_orders.erase(order)
			orders_fulled += 1
			reputation += 10
		

func remove_box_from_orders(id: int):
	for order : Order in active_orders:
		if id in order.quantitys:
			if not order.quantitys[id] == 0:
				order.quantitys[id] -= 1
	clear_fuffled_order()

func start():
	if diferculty == 1:
		diffculty_mutiplyer = 0.75
	elif diferculty == 2:
		diffculty_mutiplyer = 1
	elif diferculty == 3:
		diffculty_mutiplyer = 1.5
	elif diferculty == 4:
		diffculty_mutiplyer = 2.5

func new_order():
	if len(active_orders) >= 4:
		return
	var order: Order = Order.new()
	var max_mass: int = defult_mass * diffculty_mutiplyer * (1 + (reputation/25))
	var mass = 0
	while true:
		if mass >= max_mass:
			break
		var id_chosen = find_found_weight(randi_range(1, total_weight), weights) 

		if id_chosen in order.quantitys:
			order.quantitys[id_chosen] += 1
		else: order.quantitys[id_chosen] = 1
		mass += Box_db.Box_list.get(id_chosen).price
	
	order.id = len(active_orders) + 1
	
	var prefix = db_order_name.Prefixes[randi_range(0, db_order_name.Prefixes.size() - 1)]
	var affex = db_order_name.Affexes[randi_range(0, db_order_name.Affexes.size() - 1)]
	var suffex = db_order_name.Suffexes[randi_range(0, db_order_name.Suffexes.size() - 1)]
	order.name = prefix + " " + affex + " " + suffex
	order.timeperiod = db_order_name.time_period[randi_range(0, db_order_name.time_period.size() - 1)]
	
	print("final order " + str(order.quantitys) + ", Name: " + order.name + ", Time Period: " + order.timeperiod)
	active_orders.append(order)
	Signal_Bus.new_order.emit(len(active_orders))
	
func find_found_weight(random_number: int, box_weights: Array):
	var total: int = 0
	for i in range(len(box_weights)):
		total += box_weights[i]
		if random_number <= total:
			return i

func order_timeout(id : int):
	reputation -= 10
	active_orders.remove_at(id-1)
