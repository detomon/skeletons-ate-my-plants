extends KinematicBody2D

signal died()

const DAMAGE: = 1.0
const part_scene: PackedScene = preload("skeleton_part.tscn")

onready var animation_tree: AnimationTree = $AnimationTree
onready var parts_positions: = [
	$PartPosition1,
	#$PartPosition2,
]

var energy: = 1.0

func _die() -> void:
	animation_tree.set("parameters/death/active", true)

# called from animation
func _death() -> void:
	var parent: = get_parent()

	for i in len(parts_positions):
		var part: = part_scene.instance()
		part.part_index = i
		part.global_position = parts_positions[i].global_position
		parent.call_deferred("add_child", part)

	queue_free()
	emit_signal("died")

func _on_damage_area_entered(area: Area2D) -> void:
	var container: = area.owner

	if container.is_in_group("projectile"):
		var had_energy = energy > 0.0

		energy -= container.DAMAGE

		if had_energy:
			if energy <= 0.0:
				_die()
			else:
				animation_tree.set("parameters/hit/active", true)
