extends Control

const stage_scene: = preload("res://map/stage.tscn")
const SCENE_FADE_COLOR: = Color(0.5, 0.0, 0.0, 0.0)

onready var stage: Node2D
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
	stage = stage_scene.instance()
	stage.connect("player_collect", self, "_on_map_player_collect")
	stage.connect("planted", self, "_on_map_planted")
	viewport.add_child(stage)

	menu.pots_count = stage.pots_count

	var camera: Camera2D = stage.player.camera
	var rect: Rect2 = stage.get_used_rect()
	stage.player.set_camera_limits(rect)

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

# TODO: implement loading next stage
func load_next_map() -> void:
		tween.interpolate_property(viewport_container, "modulate", Color.white, SCENE_FADE_COLOR, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.interpolate_property(self, "music_volume", 1.0, 0.0, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")

		stage.queue_free()

		yield(get_tree().create_timer(1.0), "timeout")
		music.stop()

		reset()
		add_map()

		tween.interpolate_property(viewport_container, "modulate", SCENE_FADE_COLOR, Color.white, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")

		self.music_volume = 1.0
		music.play()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_FOCUS_OUT:
			menu.set_paused(true)
