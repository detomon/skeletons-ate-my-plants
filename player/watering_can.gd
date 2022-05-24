extends Node2D

enum AnimationState {
	STATE_IDLE,
	STATE_SPIN,
}

const DAMAGE: = 0.5
const THROW_SPEED: = 300.0
const MAX_VELOCITY: = 300.0

onready var animation_tree: AnimationTree = $AnimationTree
onready var tween: Tween = $Tween

var velocity: = Vector2.ZERO
var return_target: Node2D
var throw_time: = 0.0

var state: int = AnimationState.STATE_IDLE setget set_state
func set_state(value: int) -> void:
	state = value
	animation_tree.set("parameters/state/current", state)

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	var target_position: = return_target.global_position
	var return_dir: = global_position.direction_to(target_position)
	velocity += return_dir * 5.0
	velocity = velocity.clamped(MAX_VELOCITY)

	global_position += velocity * delta
	global_position = lerp(global_position, target_position, 0.02)

	throw_time += delta

	# is returning
	if throw_time > 0.2:
		if global_position.distance_to(target_position) < 8.0:
			set_as_toplevel(false)
			set_process(false)
			position = Vector2.ZERO
			self.state = AnimationState.STATE_IDLE

func throw(direction: Vector2, new_return_target: Node2D) -> void:
	if state != AnimationState.STATE_IDLE:
		return

	return_target = new_return_target
	velocity = direction.normalized() * THROW_SPEED
	self.state = AnimationState.STATE_SPIN

	set_as_toplevel(true)
	position = new_return_target.global_position
	throw_time = 0.0
	set_process(true)
