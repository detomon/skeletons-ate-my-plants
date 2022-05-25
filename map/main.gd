extends Control

onready var map: Node2D = $ViewportContainer/Viewport/Map
onready var menu: Control = $ViewportContainer/Viewport/Menu
onready var music: AudioStreamPlayer = $BackgroundMusic

func _ready() -> void:
	menu.pots_count = map.pots_count
	play_music()

func play_music() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	music.play()

func _on_menu_button_pressed() -> void:
	menu.pause_or_unpause()

func _on_map_player_collect(parts_count: int) -> void:
	menu.parts_count = parts_count

func _on_map_planted(plants_count: int) -> void:
	menu.plants_count = plants_count
