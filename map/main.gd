extends Control

const map_scene: = preload("res://map/map.tscn")

onready var map: Node2D
onready var menu: Control = $ViewportContainer/Viewport/CanvasLayer/Menu
onready var music: AudioStreamPlayer = $BackgroundMusic
onready var viewport_container: Control = $ViewportContainer
onready var viewport: Viewport = $ViewportContainer/Viewport
onready var tween: Tween = $Tween

var music_volume: float = 1.0 setget set_music_volume
func set_music_volume(value: float) -> void:
	music_volume = value
	music.volume_db = linear2db(music_volume)

func _ready() -> void:
	play_music()
	call_deferred("add_map")

func add_map() -> void:
	map = map_scene.instance()
	map.connect("player_collect", self, "_on_map_player_collect")
	map.connect("planted", self, "_on_map_planted")
	viewport.add_child(map)

	menu.pots_count = map.pots_count

	var camera: Camera2D = map.player.camera
	var rect: Rect2 = map.get_used_rect()
	camera.limit_left = rect.position.x
	camera.limit_right = rect.end.x
	camera.limit_top = rect.position.y
	camera.limit_bottom = rect.end.y

func reset() -> void:
	menu.parts_count = 0
	menu.plants_count = 0

func play_music() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	music.play()

func _on_menu_button_pressed() -> void:
	menu.pause_or_unpause()

func _on_map_player_collect(parts_count: int) -> void:
	menu.parts_count = parts_count

func _on_map_planted(plants_count: int, finished: bool) -> void:
	menu.plants_count = plants_count

	if finished:
		load_next_map()

# TODO: implement loading next map
func load_next_map() -> void:
		tween.interpolate_property(viewport_container, "modulate", Color.white, Color.black, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.interpolate_property(self, "music_volume", 1.0, 0.0, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")

		map.queue_free()
		reset()
		add_map()

		tween.interpolate_property(viewport_container, "modulate", Color.black, Color.white, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.interpolate_property(self, "music_volume", 0.0, 1.0, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_FOCUS_OUT:
			menu.set_paused(true)
