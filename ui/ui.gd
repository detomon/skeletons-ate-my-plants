extends Control

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused

		if get_tree().paused:
			animation_player.play("fade_in")
		else:
			animation_player.play("fade_out")
