extends Node2D

enum AnimationState {
	STATE_IDLE,
	STATE_SPIN,
}

const DAMAGE: = 0.5
const MAX_DISTANCE: = 80.0

onready var animation_tree: AnimationTree = $AnimationTree
onready var tween: Tween = $Tween

var return_target: Node2D

var state: int = AnimationState.STATE_IDLE setget set_state
func set_state(value: int) -> void:
	state = value
	animation_tree.set("parameters/state/current", state)

func throw(direction: Vector2, new_return_target: Node2D) -> void:
	if state != AnimationState.STATE_IDLE:
		return

	direction = direction.normalized()
	return_target = new_return_target
	self.state = AnimationState.STATE_SPIN

	var start_position: = global_position
	set_as_toplevel(true)
	global_position = new_return_target.global_position
	var target_position: = start_position + direction * MAX_DISTANCE

	tween.interpolate_property(self, "global_position", global_position, target_position, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.follow_property(self, "global_position", global_position, return_target, "global_position", 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

	set_as_toplevel(false)
	position = Vector2.ZERO
	self.state = AnimationState.STATE_IDLE

func _on_damage_area_entered(area: Area2D) -> void:
	var item: = area.owner

	if not item:
		item = area

	if item.is_in_group("collectible"):
		if return_target:
			return_target.owner.collect(item)
