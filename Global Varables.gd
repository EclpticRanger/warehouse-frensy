extends Node

var Box_db: box_database = load("res://Resorses/Data/db.tres")
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

var order1_timer: float = -1
var order2_timer: float = -1
var order3_timer: float = -1
var order4_timer: float = -1
var order5_timer: float = -1

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
	for order in active_orders:
		for id in order:
			if order[id] <= 0:
				order.erase(id)
		if order == {}:
			active_orders.erase(order)
			reputation += 30

func remove_box_from_orders(id: int):
	for order in active_orders:
		if id in order:
			order[id] -= 1
			break
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
	#new_order()

func new_order():
	if len(active_orders) >= 5:
		return
	var order: Dictionary[int, int]
	var max_mass: int = defult_mass * score_scale_multaplyer * diffculty_mutiplyer
	var mass = 0
	while true:
		if mass >= max_mass:
			break
		var id_chosen = find_found_weight(randi_range(1, total_weight), weights) -1

		if id_chosen in order:
			order[id_chosen] += 1
		else: order[id_chosen] = 1
		mass += Box_db.Box_list.get(id_chosen).price
	
	Signal_Bus.new_order.emit(len(active_orders) + 1)
	active_orders.append(order)

func find_found_weight(random_number: int, box_weights: Array):
	var total: int = 0
	for i in range(len(box_weights)):
		total += box_weights[i]
		if total >= random_number:
			return i + 1

func order_timeout(id : int):
	reputation -= 40
	active_orders[id-1] = {}
	clear_fuffled_order()
