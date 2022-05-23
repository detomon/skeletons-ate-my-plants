extends Area2D

export var enabled: = true setget set_enabled
func set_enabled(value: bool) -> void:
	enabled = value
	if collision:
		#sprite.visible = enabled
		collision.disabled = not enabled

onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D
onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_enabled(false)

func swing() -> void:
	if not enabled:
		animation_player.play("swing")
#
#func _on_active_timer_timeout() -> void:
#	set_enabled(false)
