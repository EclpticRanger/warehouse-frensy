extends Node

var song_playing = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chose_song()
	
func chose_song():
	song_playing = randf_range(0, 1)
	if song_playing == 0:
		$AudioStreamPlayer.play()

func song_finished() -> void:
	await  get_tree().create_timer(10).timeout
	chose_song()
