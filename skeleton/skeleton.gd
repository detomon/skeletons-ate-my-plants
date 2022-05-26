extends "res://player/actor.gd"

const DAMAGE: = 1.0
const part_scene: PackedScene = preload("skeleton_part.tscn")
const bone_scene: PackedScene = preload("bone.tscn")

export var throws_bones: = false

onready var sprite: = $Sprite
onready var throw_position: = $Sprite/ThrowPosition
onready var part_position: = $PartPosition

func _physics_process(delta: float) -> void:
	var players: = get_tree().get_nodes_in_group("player")
	if not players.empty():
		var player: Node2D = players[0]
		var to_player: = global_position.direction_to(player.global_position)

		_handle_walking(to_player, delta)

func _handle_walking(direction: Vector2, delta: float) -> void:
	._handle_walking(direction, delta)

	if abs(direction.x) > 0.1:
		sprite.scale.x = -1.0 if direction.x < 0.0 else 1.0

func _get_speed() -> float:
	return 10.0

func _die() -> void:
	animation_tree.set("parameters/death/active", true)

# called from animation
func _death() -> void:
	var parent: = get_parent()
	var part: = part_scene.instance()
	part.global_position = part_position.global_position
	parent.call_deferred("add_child", part)

	queue_free()
	emit_signal("die")

func _throw() -> void:
	var player: Node2D = owner.player
	var bone: = bone_scene.instance()
	bone.set_as_toplevel(true)
	bone.global_position = throw_position.global_position
	bone.direction = throw_position.global_position.direction_to(player.global_position)
	get_parent().add_child(bone)

func _on_damage_area_entered(area: Area2D) -> void:
	var container: = area.owner

	if container.is_in_group("weapon"):
		var had_energy = energy > 0.0

		energy -= container.DAMAGE

		if had_energy:
			if energy <= 0.0:
				_die()
			else:
				animation_tree.set("parameters/hit/active", true)

func _on_screen_entered() -> void:
	print("_on_screen_entered")

func _on_screen_exited() -> void:
	print("_on_screen_exited")

func _on_throw_timer_timeout() -> void:
	if not is_death() and throws_bones:
		if rand_range(0.0, 1.0) < 0.2:
			_throw()
