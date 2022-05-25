extends KinematicBody2D

signal die()

const VELOCITY_INTERP: = 0.5

onready var animation_tree: AnimationTree = $AnimationTree

var energy: = 1.0
var direction: = Vector2.ZERO
var velocity: = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true

func _handle_walking(direction: Vector2) -> void:
	var speed: = _get_speed()
	velocity = velocity.linear_interpolate(direction * speed, VELOCITY_INTERP)
	velocity = move_and_slide(velocity)

	animation_tree.set("parameters/walk/blend_position", round(velocity.length() / speed))

func is_death() -> bool:
	return energy <= 0.0

func _get_speed() -> float:
	return 125.0

func _reset_energy() -> void:
	energy = 1.0
