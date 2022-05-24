extends Control

onready var music: AudioStreamPlayer = $BackgroundMusic

func _ready() -> void:
	play_music()

func play_music() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	music.play()
