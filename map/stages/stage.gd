extends Node2D

signal player_collect(parts_count)
signal planted(plants_count, finished)

export var stage_number: = 1
export var stage_name: = "Stage"

onready var player: Node2D = $TileMap/Player
onready var player_start: Node2D = $TileMap/PlayerStart
onready var map: TileMap = $TileMap

var pots_count: = 0
var plants_count: = 0

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_STOP
	pots_count = _count_pots()

func _count_pots() -> int:
	var count: = 0
	for child in map.get_children():
		if child.is_in_group("pot"):
			count += 1

	return count

func get_used_rect() -> Rect2:
	var rect: = map.get_used_rect()
	return Rect2(rect.position * map.cell_size, rect.size * map.cell_size)

func _on_player_collect(parts_count: int) -> void:
	emit_signal("player_collect", parts_count)

func reset_player() -> void:
	player.global_position = player_start.global_position

func clear_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()

func clear_projectiles() -> void:
	for projectile in get_tree().get_nodes_in_group("projectile"):
		projectile.queue_free()

func reset() -> void:
	plants_count = 0
	emit_signal("planted", plants_count)

func _on_player_die() -> void:
	clear_projectiles()
	reset_player()

func _on_pot_planted() -> void:
	plants_count += 1
	var finished: = plants_count >= pots_count
	emit_signal("planted", plants_count, finished)
