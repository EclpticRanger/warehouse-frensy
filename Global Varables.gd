extends Node

var score : int = 0
#Difficulty
#1 = Easy
#2 = Normal
#3 = Hard
#4 = Arsonist
var diferculty : int = 1

var food_purchsed: int = 0
var money : float = 10000000000

var active_orders: Array = []
var orders_fulled: int = 0

func reset_values():
	score = 0
	diferculty = 2
	food_purchsed = 0
	money = 100
	active_orders = []
	orders_fulled = 0

func clear_fuffled_order():
	for order in active_orders:
		for id in order:
			if order[id] <= 0:
				order.erase(id)

func remove_box_from_orders(id: int):
	for order in active_orders:
		if id in order:
			order[id] -= 1
			break
	clear_fuffled_order()
