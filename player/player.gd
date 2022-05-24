extends KinematicBody2D

const SPEED: = 125.0
const VELOCITY_INTERP: = 0.5

onready var sprite: Sprite = $Sprite
onready var weapon: Node2D = $Sprite/WeaponPosition/WateringCan
onready var weapon_return_target: Node2D = $Sprite/WeaponPosition
onready var animation_tree: AnimationTree = $AnimationTree
onready var collect_audio: AudioStreamPlayer = $CollectAudio

var energy: = 1.0
var direction: = Vector2.ZERO
var velocity: = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true

func _process(delta: float) -> void:
	var left: = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var up: = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	direction = Vector2(left, up).normalized()
	velocity = velocity.linear_interpolate(direction * SPEED, VELOCITY_INTERP)
	velocity = move_and_slide(velocity)

	if abs(direction.x) > 0.1:
		sprite.scale.x = -1.0 if direction.x < 0.0 else 1.0

	animation_tree.set("parameters/walk/blend_position", round(velocity.length() / SPEED))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var throw_dir: = Vector2.ZERO

		if direction.length() > 0.1:
			# use move speed
			throw_dir = direction
		else:
			# use facing direction when stading
			throw_dir = sprite.global_transform.basis_xform(Vector2.RIGHT)

		weapon.throw(throw_dir, weapon_return_target)

func _on_interaction_area_entered(area: Area2D) -> void:
	var container: = area.owner
	if not container:
		container = area

	if container.is_in_group("enemy"):
		energy -= container.DAMAGE
		print("harm", energy)

	elif container.is_in_group("collectible"):
		collect_audio.play()
		container.queue_free()
