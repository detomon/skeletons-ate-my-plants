extends Node2D

signal player_collect(parts_count)
signal planted(plants_count)

const skeleton_scene: PackedScene = preload("res://skeleton/skeleton.tscn")

onready var player: Node2D = $TileMap/Player
onready var player_start: Node2D = $TileMap/PlayerStart
onready var map: Node2D = $TileMap

var pots_count: = 0
var plants_count: = 0

func _ready() -> void:
	for i in 10:
		_add_enemy()

	pots_count = _count_pots()

func _count_pots() -> int:
	var count: = 0
	for child in map.get_children():
		if child.is_in_group("pot"):
			count += 1

	return count

func _add_enemy() -> void:
	var position: = Vector2(randi() % 400, randi() % 200)
	var enemy: Node2D = skeleton_scene.instance()
	enemy.position = position
	enemy.connect("died", self, "_on_enemy_died")
	enemy.set_as_toplevel(true)

	add_child(enemy)

func _on_enemy_died() -> void:
	_add_enemy()

func _on_player_collect(parts_count: int) -> void:
	emit_signal("player_collect", parts_count)

func reset_player() -> void:
	player.global_position = player_start.global_position

func reset() -> void:
	plants_count = 0
	emit_signal("planted", plants_count)

func _on_player_die() -> void:
	reset_player()

func _on_pot_planted() -> void:
	plants_count += 1
	emit_signal("planted", plants_count)
