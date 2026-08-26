extends CharacterBody2D

var is_holding: bool = false

var move_speed: int = 20000
var fuel: float = 100
var fuel_rate: float = 0.5
var fuel_refule_rate: float = 3

var in_pickup_range: Array = []

var holing

@onready var UI_Control_Node = $UI/UI
@onready var in_game_ui = $"UI/UI/in game ui"
@onready var shop_ui = $"UI/UI/Shop menu"

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	Signal_Bus.emit_signal("change_fuel", [fuel])
	if Input.is_action_just_pressed("menu") or Input.is_action_just_pressed("ui_cancel"):
		var can_menu: bool = (Globals.tutoral_level in [0])
		if can_menu:
			in_game_ui.visible = not in_game_ui.visible 
			shop_ui.visible = not shop_ui.visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	Globals.clear_fuffled_order()
	handel_movement(delta)
	handel_refuel(delta)
	handel_pickup()


func handel_movement(delta):
	var forward_back = Input.get_axis("down", "up")
	var left_right = Input.get_axis("left", "right")
	if abs(forward_back) > 0 and abs(left_right) > 0:
		var emit_particle = true
		$Particles/GPUParticles2D.emitting = emit_particle
		$Particles/GPUParticles2D/GPUParticles2D.emitting = emit_particle
		$Particles/GPUParticles2D/GPUParticles2D/GPUParticles2D.emitting = emit_particle
		$Particles/GPUParticles2D/GPUParticles2D/GPUParticles2D/GPUParticles2D.emitting = emit_particle
	else:
		var emit_particle = false
		$Particles/GPUParticles2D.emitting = emit_particle
		$Particles/GPUParticles2D/GPUParticles2D.emitting = emit_particle
		$Particles/GPUParticles2D/GPUParticles2D/GPUParticles2D.emitting = emit_particle
		$Particles/GPUParticles2D/GPUParticles2D/GPUParticles2D/GPUParticles2D.emitting = emit_particle
	
	if forward_back != 0 or left_right != 0:
		fuel -= delta * fuel_rate 
	rotation += left_right * delta * 4
	velocity = Vector2.UP.rotated(rotation) * forward_back * move_speed * delta
	move_and_slide()


func handel_refuel(delta):
	if Input.is_action_pressed("refuel") and len($"Refull Detection".get_overlapping_areas()) > 0:
		if fuel < 100 and Globals.money > 0:
			fuel += fuel_refule_rate * delta * 10
			Globals.money -= delta * 10
			$AudioListener2D/refuel.playing = true
		elif fuel > 100:
			fuel = 100
			$AudioListener2D/refuel.playing = false
		else:
			$AudioListener2D/refuel.playing = false
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
			if holing.can_drop():
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


func _on__pressed(_extra_arg_0: int) -> void:
	pass # Replace with function body.
