extends KinematicBody2D

const SPEED: = 120.0
const VELOCITY_INTERP: = 0.5

onready var sprite: Sprite = $Sprite
onready var weapon: Node2D = $Sprite/Weapon
onready var animation_tree: AnimationTree = $AnimationTree
onready var collect_audio: AudioStreamPlayer = $CollectAudio

var velocity: = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true

func _process(delta: float) -> void:
	var left: = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var up: = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	var velocity_abs: = Vector2(left, up).normalized() * SPEED
	velocity = velocity.linear_interpolate(velocity_abs, VELOCITY_INTERP)
	var is_walking: = velocity_abs.length() > 0.01

	if is_walking:
		sprite.scale.x = -1.0 if velocity_abs.x < 0.0 else 1.0

	animation_tree.set("parameters/walk/blend_position", round(velocity.length() / SPEED))

	move_and_slide(velocity)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		weapon.swing()

func _on_interaction_area_entered(area: Area2D) -> void:
	var part: = area.owner
	if not part:
		part = area

	collect_audio.play()
	part.queue_free()
