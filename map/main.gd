extends Control

onready var map: Node2D = $ViewportContainer/Viewport/Map
onready var menu: Control = $ViewportContainer/Viewport/CanvasLayer/Menu
onready var music: AudioStreamPlayer = $BackgroundMusic

func _ready() -> void:
	menu.pots_count = map.pots_count
	play_music()

	var camera: Camera2D = map.player.camera
	var rect: Rect2 = map.get_used_rect()
	camera.limit_left = rect.position.x
	camera.limit_right = rect.end.x
	camera.limit_top = rect.position.y
	camera.limit_bottom = rect.end.y

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

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_FOCUS_OUT:
			menu.set_paused(true)
