extends "res://actor.gd"

signal collect(node, parts_count)

onready var sprite: Sprite = $Sprite
onready var weapon: Node2D = $Sprite/WeaponPosition/WateringCan
onready var weapon_return_target: Node2D = $Sprite/WeaponPosition
onready var collect_audio: AudioStreamPlayer = $CollectAudio
onready var interaction_area: Area2D = $InteractionArea
onready var camera: Camera2D = $Camera2D

var parts_count: = 0

func _process(delta: float) -> void:
	if is_death():
		return

	var left: = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var up: = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	direction = Vector2(left, up).normalized()
	_handle_walking(direction)

func _handle_walking(direction: Vector2) -> void:
	._handle_walking(direction)

	if abs(direction.x) > 0.1:
		sprite.scale.x = -1.0 if direction.x < 0.0 else 1.0

func _input(event: InputEvent) -> void:
	if is_death():
		return

	if event.is_action_pressed("shoot"):
		var throw_dir: = Vector2.ZERO

		if direction.length() > 0.1:
			# use move speed
			throw_dir = direction
		else:
			# use facing direction when stading
			throw_dir = sprite.global_transform.basis_xform(Vector2.RIGHT)

		weapon.throw(throw_dir, weapon_return_target)

func _on_interaction_area_entered(area: Area2D) -> void:
	if is_death():
		return

	var container: = area.owner
	if not container:
		container = area

	if container.is_in_group("enemy"):
		energy -= container.DAMAGE
		if energy <= 0.0:
			_die()

	elif container.is_in_group("collectible"):
		collect(container)

func _die() -> void:
	weapon.reset()
	weapon.visible = false
	animation_tree.set("parameters/death/active", true)

# called from animation
func _respawn() -> void:
	weapon.visible = true
	animation_tree.set("parameters/invincible/active", true)
	emit_signal("die")

func _reset_energy() -> void:
	energy = 1.0

func collect(node: Node2D) -> void:
	collect_audio.play()
	node.queue_free()
	parts_count += 1
	emit_signal("collect", parts_count)

func can_plant() -> bool:
	return parts_count >= PlantPot.PARTS_NEEDED

# called from pot
func plant() -> void:
	if can_plant():
		parts_count -= PlantPot.PARTS_NEEDED
		emit_signal("collect", parts_count)
