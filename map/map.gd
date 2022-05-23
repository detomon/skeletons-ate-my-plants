extends Control

const skeleton_scene: PackedScene = preload("res://skeleton/skeleton.tscn")

func _ready() -> void:
	for i in 10:
		add_enemy()

func add_enemy() -> void:
	var position: = Vector2(randi() % 400, randi() % 200)
	var enemy: Node2D = skeleton_scene.instance()
	enemy.position = position
	enemy.set_as_toplevel(true)

	enemy.connect("died", self, "_on_enemy_died")

	add_child(enemy)

func _on_enemy_died() -> void:
	add_enemy()
