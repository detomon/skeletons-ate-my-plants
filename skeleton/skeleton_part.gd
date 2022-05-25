extends Node2D

onready var sprite: Sprite = $Sprite

export var part_index: = 0

func _ready() -> void:
	set_as_toplevel(true)
	sprite.frame = part_index % sprite.hframes

func _process(_delta: float) -> void:
	sprite.visible = (get_tree().get_frame() / 2) % 2 == 0
