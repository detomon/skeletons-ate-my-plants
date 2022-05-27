extends Control

signal play()
signal quit()

onready var drop_audio: AudioStreamPlayer = $DropAudio

func _on_play_pressed() -> void:
	if modulate != Color.white:
		return

	drop_audio.play()
	emit_signal("play")

func _on_quit_button_pressed() -> void:
	emit_signal("quit")
