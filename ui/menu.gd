extends Control

export var pots_count: = 0 setget set_pots_count
func set_pots_count(value: int) -> void:
	pots_count = value
	set_plants_count(plants_count)

onready var music_volume: HSlider = $MenuContainer/CenterContainer/VBoxContainer/MusicVolume
onready var effects_volume: HSlider = $MenuContainer/CenterContainer/VBoxContainer/EffectsVolume
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var menu_container: Control = $MenuContainer
onready var parts_count_label: Label = $MarginContainer/Bottom/PartsCountLabel
onready var plants_count_label: Label = $MarginContainer/Bottom/PlantsCountLabel

var parts_count: = 0 setget set_parts_count
func set_parts_count(value: int) -> void:
	parts_count = value
	parts_count_label.text = "x%02d" % parts_count

var plants_count: = 0 setget set_plants_count
func set_plants_count(value: int) -> void:
	plants_count = value
	plants_count_label.text = "%d/%d" % [plants_count, pots_count]

var music_bus_index: = _get_bus_index("Music")
var effects_bus_index: = _get_bus_index("Effects")

func _ready() -> void:
	music_volume.value = db2linear(AudioServer.get_bus_volume_db(music_bus_index))
	effects_volume.value = db2linear(AudioServer.get_bus_volume_db(effects_bus_index))
	menu_container.visible = false
	reset()

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

func reset() -> void:
	set_parts_count(0)
	set_plants_count(0)

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
