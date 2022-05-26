extends Control

const stage_scene: = preload("res://map/stage.tscn")
const SCENE_FADE_COLOR: = Color(0.75, 0.0, 0.0, 0.0)
const FADE_TIME: = 0.5

onready var stage: Node2D
onready var menu_container: Control = $ViewportContainer/Viewport/CanvasLayer/MenuContainer
onready var menu: Control = $ViewportContainer/Viewport/CanvasLayer/MenuContainer/Menu
onready var music: AudioStreamPlayer = $BackgroundMusic
onready var victory_music: AudioStreamPlayer = $VictoryMusic
onready var game_container: Control = $ViewportContainer/Viewport/GameContainer
onready var viewport: Viewport = $ViewportContainer/Viewport
onready var stage_name_container: Control = $ViewportContainer/Viewport/StageNameContainer
onready var stage_name: Label = $ViewportContainer/Viewport/StageNameContainer/StageName
onready var tween: Tween = $Tween

func _ready() -> void:
	game_container.modulate = SCENE_FADE_COLOR
	menu_container.modulate = SCENE_FADE_COLOR
	menu.visible = false
	stage_name_container.visible = false
	call_deferred("load_next_map")

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
	tween.interpolate_property(menu_container, "modulate", menu_container.modulate, SCENE_FADE_COLOR, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(game_container, "modulate", game_container.modulate, SCENE_FADE_COLOR, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")

	music.stop()
	if stage:
		stage.queue_free()

func load_stage(new_stage: Node2D) -> void:
	_add_stage(new_stage)
	reset()

	menu.visible = true # hidden in stage outro
	tween.interpolate_property(menu_container, "modulate", SCENE_FADE_COLOR, Color.white, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.interpolate_property(game_container, "modulate", SCENE_FADE_COLOR, Color.white, FADE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

	music.play()

func finish_stage() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	for projectile in get_tree().get_nodes_in_group("projectile"):
		projectile.queue_free()

	music.stop()
	menu.visible = false

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

# TODO: implement loading next stage
func load_next_map() -> void:
	yield(unload_stage(), "completed")
	yield(get_tree().create_timer(1.0), "timeout")

	stage = stage_scene.instance()
	stage_name.text = "STAGE %d\n\n%s" % [stage.stage_number, stage.stage_name]
	stage_name_container.visible = true

	yield(get_tree().create_timer(3.0), "timeout")
	stage_name_container.visible = false

	yield(get_tree().create_timer(0.5), "timeout")
	yield(load_stage(stage), "completed")

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_FOCUS_OUT:
			menu.set_paused(true)
