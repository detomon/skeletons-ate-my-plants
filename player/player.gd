extends "res://player/actor.gd"

signal collect(node, parts_count)

onready var sprite: Sprite = $Sprite
onready var weapon: Node2D = $Sprite/WeaponPosition/WateringCan
onready var weapon_position: Node2D = $Sprite/WeaponPosition
onready var collect_audio: AudioStreamPlayer = $CollectAudio
onready var interaction_area: Area2D = $InteractionArea
onready var camera: Camera2D = $Camera2D

var parts_count: = 0

func _process(delta: float) -> void:
	direction = Vector2.ZERO

	if is_death():
		return

	var left: = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var up: = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	direction = Vector2(left, up).normalized()

func _physics_process(delta: float) -> void:
	_handle_walking(direction, delta)

func _handle_walking(direction: Vector2, delta: float) -> void:
	._handle_walking(direction, delta)

	if abs(direction.x) > 0.1:
		sprite.scale.x = -1.0 if direction.x < 0.0 else 1.0

func _unhandled_input(event: InputEvent) -> void:
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

		weapon.throw(throw_dir, weapon_position)

	elif event.is_action_pressed("click_left"):
		var local_event: = make_input_local(event)
		var throw_dir: Vector2 = local_event.position

		weapon.throw(throw_dir, weapon_position)

func _on_interaction_area_entered(area: Area2D) -> void:
	if is_death():
		return

	var container: = area.owner if area.owner else area

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

func can_plant(count: int) -> bool:
	return parts_count >= count

# called from pot
func plant(count: int) -> void:
	if can_plant(count):
		parts_count -= count
		emit_signal("collect", parts_count)

func set_camera_limits(rect: Rect2) -> void:
	camera.limit_left = rect.position.x
	camera.limit_right = rect.end.x
	camera.limit_top = rect.position.y
	camera.limit_bottom = rect.end.y
