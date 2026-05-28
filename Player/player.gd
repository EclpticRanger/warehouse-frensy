extends CharacterBody2D

var is_holding: bool = false

var move_speed: int = 20000
var fuel: float = 100
var fuel_rate: float = 1.5

#Key: 1 = in game ui
#     2 = shop ui
#     3 = orders ui
var ui_in: int = 1

var in_pickup_range: Array = []

var holing

@onready var UI_Control_Node = $UI/UI


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	Signal_Bus.emit_signal("change_fuel", [fuel])
	handel_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	handel_movement(delta)
	handel_refuel(delta)
	handel_pickup()

func handel_movement(delta):
	var forward_back = Input.get_axis("down", "up")
	var left_right = Input.get_axis("left", "right")
	
	if forward_back != 0 or left_right != 0:
		fuel -= delta * fuel_rate
	rotation += left_right * delta * 4
	velocity = Vector2.UP.rotated(rotation) * forward_back * move_speed * delta
	move_and_slide()

func handel_ui():
	if Input.is_action_just_pressed("order menu"):
		UI_Control_Node.try_open_or_close_ui(3)
	if Input.is_action_just_pressed("shop menu"):
		UI_Control_Node.try_open_or_close_ui(2)


func handel_refuel(delta):
	if Input.is_action_pressed("refuel") and len($"Refull Detection".get_overlapping_areas()) > 0:
		fuel += fuel_rate * delta * 10
		if fuel > 100:
			fuel = 100
		if Input.is_action_just_pressed("refuel"):
			Signal_Bus.emit_signal("fuel_start")
	elif Input.is_action_just_released("refuel"):
		Signal_Bus.emit_signal("fuel_end")

func handel_pickup():
	if Input.is_action_just_pressed("pickup"):
		if is_holding==false:
			if len(in_pickup_range) < 1:
				pass
			elif len(in_pickup_range) > 1:
				hold_box(in_pickup_range[randi_range(0, len(in_pickup_range)-1)])
			else: hold_box(in_pickup_range[0])
		elif is_holding==true:
			release_box(holing)

func hold_box(_box_node):
	is_holding = true
	holing= _box_node
	_box_node.player = self
	_box_node.being_held = true

func release_box(_held_box):
	is_holding = false
	holing = null
	_held_box.player = null
	_held_box.being_held = false

func _on_body_enter_pickup_area(body: Node2D) -> void:
	if body.is_in_group("Pickapable"):
		in_pickup_range.append(body)


func _on_body_exit_pickup_area(body: Node2D) -> void:
	if body in in_pickup_range:
		in_pickup_range.erase(body)
