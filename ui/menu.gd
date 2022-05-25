extends Control

onready var music_volume: HSlider = $MenuContainer/CenterContainer/VBoxContainer/MusicVolume
onready var effects_volume: HSlider = $MenuContainer/CenterContainer/VBoxContainer/EffectsVolume
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var menu_container: Control = $MenuContainer

var music_bus_index: = _get_bus_index("Music")
var effects_bus_index: = _get_bus_index("Effects")

func _ready() -> void:
	music_volume.value = db2linear(AudioServer.get_bus_volume_db(music_bus_index))
	effects_volume.value = db2linear(AudioServer.get_bus_volume_db(effects_bus_index))
	menu_container.visible = false

func _get_bus_index(bus_name: String) -> int:
	for i in AudioServer.bus_count:
		var name: = AudioServer.get_bus_name(i)
		if name == bus_name:
			return i
	return -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_or_unpause()

func pause_or_unpause() -> void:
	var tree: = get_tree()
	tree.paused = not tree.paused

	if tree.paused:
		animation_player.play("fade_in")
	else:
		animation_player.play("fade_out")

func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear2db(value))

func _on_effects_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(effects_bus_index, linear2db(value))

func _on_continue_pressed() -> void:
	pause_or_unpause()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	pause_or_unpause()
