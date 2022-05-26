extends Node2D

const SPEED: = 40.0
const DAMAGE: = 1.0

onready var animation_player: AnimationPlayer = $AnimationPlayer

var direction: = Vector2.ZERO

func _process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_remove_timer_timeout() -> void:
	blink()

func blink() -> void:
	animation_player.play("blink")

func die() -> void:
	queue_free()

func _on_damage_area_entered(area: Area2D) -> void:
	var container: = area.owner

	if container.is_in_group("weapon"):
		animation_player.play("hit")
