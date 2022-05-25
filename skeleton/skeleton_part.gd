extends Node2D

onready var sprite: Sprite = $Sprite

func _ready() -> void:
	set_as_toplevel(true)

func _process(_delta: float) -> void:
	sprite.visible = (get_tree().get_frame() / 2) % 2 == 0
