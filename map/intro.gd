extends Control

signal play()

onready var drop_audio: AudioStreamPlayer = $DropAudio

func _on_play_pressed() -> void:
	drop_audio.play()
	emit_signal("play")
