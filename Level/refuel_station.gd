extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signal_Bus.connect("fuel_start", start_fuling)
	Signal_Bus.connect("fuel_end", stop_fuling)

func start_fuling():
	$GPUParticles2D.emitting = true

func stop_fuling():
	$GPUParticles2D.emitting = false
