extends AnimatedSprite2D

@onready var player = $"../.."
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var fuel = player.fuel
	print(fuel)
	if fuel > 95:
		play("Full")
	elif fuel > 90:
		play("95")
	elif fuel > 85:
		play("90")
	elif fuel > 80:
		play("85")
	elif fuel > 75:
		play("80")
	elif fuel > 60:
		play("75")
	elif fuel > 65:
		play("70")
	elif fuel > 60:
		play("65")
	elif fuel > 55:
		play("60")
	elif fuel > 50:
		play("55")
	elif fuel > 45:
		play("50")
	elif fuel > 40:
		play("45")
	elif fuel > 35:
		play("40")
	elif fuel > 30:
		play("35")
	elif fuel > 25:
		play("30")
	elif fuel > 20:
		play("25")
	elif fuel > 15:
		play("20")
	elif fuel > 10:
		play("15")
	elif fuel > 5:
		play("10")
	elif fuel > 0:
		play("05")
	else: play("00%")
	
	
	
