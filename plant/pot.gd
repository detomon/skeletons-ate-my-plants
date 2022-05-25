extends Node2D
class_name PlantPot

signal planted()

export var parts_needed: = 7

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var missing_parts_label: Control = $MissingPartsLabel
onready var arrow_sprite: Sprite = $ArrowSprite
onready var count_label: Control = $MissingPartsLabel/Container/Label

var has_plant: = false

func _ready() -> void:
	missing_parts_label.visible = false
	arrow_sprite.visible = true
	count_label.text = "x%d" % parts_needed

func plant() -> void:
	if has_plant:
		return

	missing_parts_label.visible = false
	arrow_sprite.visible = false
	has_plant = true

	animation_player.play("plant")
	yield(animation_player, "animation_finished")

	emit_signal("planted")

func _on_interaction_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if not has_plant:
			if body.can_plant(parts_needed):
				body.plant(parts_needed)
				plant()
			else:
				missing_parts_label.visible = true
				arrow_sprite.visible = false

func _on_interaction_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if not has_plant:
			missing_parts_label.visible = false
			arrow_sprite.visible = true
