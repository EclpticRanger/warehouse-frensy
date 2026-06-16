extends Node
#          0     1                    2                            3              4          5       6       7          8          9 
#   Name   ID | Name |             Seene path              |  Texture Path   |Radioticity|Toxisity|Price|Sell Worth|Order time| Waight
var box1 = [1, "Name", "res://Level/Food scene/box.tscn", "res://icon.svg",        0,        0,      10,    20,        5,        100]
var box2 = [2, "Name", "res://Level/Food scene/box.tscn", "res://icon.svg",        0,        0,      15,    20,        5,        65]
var box3 = [3, "Name", "res://Level/Food scene/box.tscn", "res://icon.svg",        0,        0,      20,    20,        5,        40]


var Boxes_ids: Dictionary[int, Array] = {
	1 : box1,
	2 : box2,
	3 : box3
}

var game_scene_file_path : String = "res://Level/map.tscn"

var score_scale_multerplyer_scaling: float = 0.01
var score_scale_multaplyer: float = 1
var defult_mass: float = 40
var total_weight = 0
var _box_weights: Array = [box1[9], box2[9], box3[9]]
var diffculty_mutiplyer = 1

func _ready() -> void:
	for i in Boxes_ids:
		total_weight += Boxes_ids[i][9]
		

func start():
	if Globals.diferculty == 1:
		diffculty_mutiplyer = 0.75
	elif Globals.diferculty == 2:
		diffculty_mutiplyer = 1
	elif Globals.diferculty == 3:
		diffculty_mutiplyer = 1.5
	elif Globals.diferculty == 4:
		diffculty_mutiplyer = 2.5
	new_order()

func new_order():
	if len(Globals.active_orders) >= 5:
		return
	var order: Dictionary[int, int]
	var max_mass: int = defult_mass * score_scale_multaplyer * diffculty_mutiplyer
	var mass = 0
	while true:
		if mass >= max_mass:
			break
		var id_chosen = find_found_weight(randi_range(1, total_weight), _box_weights)

		if id_chosen in order:
			order[id_chosen] += 1
		else: order[id_chosen] = 1
		mass += Boxes_ids[id_chosen][6]
	
	print(order)
	Globals.active_orders.append(order)

func find_found_weight(random_number: int, weights: Array):
	var total: int = 0
	for i in range(len(weights)):
		total += weights[i]
		if total >= random_number:
			return i + 1
	
