extends Control

const SCENES: = [
	"res://map/stages/stage_1.tscn",
	"res://map/stages/stage_2.tscn",
	"res://map/stages/stage_3.tscn",
	"res://map/stages/stage_4.tscn",
]

const FADE_COLOR: = Color(0.75, 0.0, 0.0, 0.0)
const FADE_TIME: = 0.5

onready var stage: Node2D
onready var menu_container: Control = $ViewportContainer/Viewport/CanvasLayer/MenuContainer
onready var menu: Control = $ViewportContainer/Viewport/CanvasLayer/MenuContainer/Menu
onready var intro: Control = $ViewportContainer/Viewport/CanvasLayer/Intro
onready var outro: Control = $ViewportContainer/Viewport/CanvasLayer/Outro
onready var music: AudioStreamPlayer = $BackgroundMusic
onready var victory_music: AudioStreamPlayer = $VictoryMusic
onready var game_container: Node2D = $ViewportContainer/Viewport/GameContainer
onready var viewport: Viewport = $ViewportContainer/Viewport
onready var stage_name_container: Control = $ViewportContainer/Viewport/CanvasLayer/StageNameContainer
onready var stage_name: Label = $ViewportContainer/Viewport/CanvasLayer/StageNameContainer/StageName
onready var tween: Tween = $Tween

var scene_index: = 0

var music_volume: = 1.0 setget set_music_volume
func set_music_volume(value: float) -> void:
	music_volume = value
	music.volume_db = linear2db(music_volume)

func _ready() -> void:
	game_container.modulate = FADE_COLOR
	menu_container.modulate = FADE_COLOR

	menu.visible = false
	stage_name_container.visible = false

	intro.modulate = FADE_COLOR
	intro.visible = false
	outro.modulate = FADE_COLOR
	outro.visible = false

	fade_in(intro)

func _add_stage(new_state: Node2D) -> void:
	stage = new_state
	stage.connect("player_collect", self, "_on_map_player_collect")
	stage.connect("planted", self, "_on_map_planted")
	game_container.add_child(stage)

	menu.pots_count = stage.pots_count

	var camera: Camera2D = stage.player.camera
	var rect: Rect2 = stage.get_used_rect()
	stage.player.set_camera_limits(rect)

func unload_stage() -> void:
	tween.interpolate_property(menu_container, "modulate", Color.white, FADE_COLOR, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(game_container, "modulate", Color.white, FADE_COLOR, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")

	music.stop()
	if stage:
		stage.queue_free()
		stage = null

func load_stage(new_stage: Node2D) -> void:
	_add_stage(new_stage)
	reset()

	menu.visible = true # hidden in stage outro
	tween.interpolate_property(menu_container, "modulate", FADE_COLOR, Color.white, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.interpolate_property(game_container, "modulate", FADE_COLOR, Color.white, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

	set_music_volume(1.0)
	music.play()

func finish_stage() -> void:
	stage.clear_enemies()
	stage.clear_projectiles()

	menu.visible = false

	tween.interpolate_property(self, "music_volume", music_volume, 0.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	music.stop()

	yield(get_tree().create_timer(0.5), "timeout")
	victory_music.play()
	yield(victory_music, "finished")
	yield(get_tree().create_timer(1.0), "timeout")

	load_next_map()

func reset() -> void:
	menu.parts_count = 0
	menu.plants_count = 0

func _on_menu_button_pressed() -> void:
	menu.pause_or_unpause()

func _on_map_player_collect(parts_count: int) -> void:
	menu.parts_count = parts_count

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_home"):
		finish_stage()

func _on_map_planted(plants_count: int, finished: bool) -> void:
	menu.plants_count = plants_count

	if finished:
		finish_stage()

func fade_in(node: CanvasItem) -> void:
	node.visible = true
	tween.interpolate_property(node, "modulate", FADE_COLOR, Color.white, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

func fade_out(node: CanvasItem) -> void:
	tween.interpolate_property(node, "modulate", Color.white, FADE_COLOR, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	node.visible = false

# TODO: implement loading next stage
func load_next_map() -> void:
	yield(unload_stage(), "completed")
	yield(get_tree().create_timer(1.0), "timeout")

	if scene_index < len(SCENES):
		var stage_scene: PackedScene = load(SCENES[scene_index])
		stage = stage_scene.instance()
		scene_index += 1

		stage_name.text = "STAGE %d\n\n%s" % [stage.stage_number, stage.stage_name]
		stage_name_container.visible = true

		yield(get_tree().create_timer(3.0), "timeout")
		stage_name_container.visible = false

		yield(get_tree().create_timer(0.5), "timeout")
		yield(load_stage(stage), "completed")

	else:
		outro.visible = true
		fade_in(outro)

# Don't
#func _notification(what: int) -> void:
#	match what:
#		NOTIFICATION_WM_FOCUS_OUT:
#			menu.set_paused(true)

func _on_intro_play() -> void:
	if tween.is_active():
		return

	yield(fade_out(intro), "completed")
	load_next_map()

func _on_outro_play() -> void:
	if tween.is_active():
		return

	yield(fade_out(outro), "completed")
	scene_index = 0
	load_next_map()
