extends KinematicBody2D

signal died()

const part_scene: PackedScene = preload("skeleton_part.tscn")

onready var  animation_tree: AnimationTree = $AnimationTree

var energy: = 1.0

func die() -> void:
	animation_tree.set("parameters/death/active", true)

func _death() -> void:
	var parent: = get_parent()

	for i in 2:
		var part: = part_scene.instance()
		part.part_index = i
		part.position = global_position + Vector2(randi() % 12 - 6, randi() % 12 - 6)
		parent.call_deferred("add_child", part)

	queue_free()
	emit_signal("died")

func _on_damage_area_entered(area: Area2D) -> void:
	var had_energy = energy > 0.0

	energy -= 0.25

	if energy <= 0.0 and had_energy:
		die()
