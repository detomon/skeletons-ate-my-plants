extends "res://player/actor.gd"

const DAMAGE: = 1.0
const PLAYER_MAX_DISTANCE: = 150.0
const part_scene: PackedScene = preload("skeleton_part.tscn")
const bone_scene: PackedScene = preload("bone.tscn")

export var throws_bones: = false

onready var sprite: = $Sprite
onready var throw_position: = $Sprite/ThrowPosition
onready var part_position: = $PartPosition
onready var ray_cast: RayCast2D = $RayCast2D

onready var start_position: = global_position

func _physics_process(delta: float) -> void:
	var players: = get_tree().get_nodes_in_group("player")
	if not players.empty():
		var player: Node2D = players[0]
		var player_target: Vector2 = player.global_transform.xform(Vector2(0.0, -2.0))
		var to_target: = player_target - global_position

		ray_cast.cast_to = to_target.clamped(PLAYER_MAX_DISTANCE)

		if not _is_player_visible():
			to_target = start_position - global_position

		if to_target.length() < 4.0:
			to_target = Vector2.ZERO

		var direction: = to_target.normalized()
		_handle_walking(direction, delta)

func _handle_walking(direction: Vector2, delta: float) -> void:
	._handle_walking(direction, delta)

	if abs(direction.x) > 0.1:
		sprite.scale.x = -1.0 if direction.x < 0.0 else 1.0

func _get_speed() -> float:
	return 25.0

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

func _is_player_visible() -> bool:
	if not ray_cast.is_colliding():
		return false

	return ray_cast.get_collider().is_in_group("player")

func _throw() -> void:
	if not _is_player_visible():
		return

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
		#if rand_range(0.0, 1.0) < 1.0:
		_throw()
