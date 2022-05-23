extends Node2D

const spawn_bug: PackedScene = preload("res://spawn/spawn_bug.tscn")

onready var map: Node2D = $Map

#func _ready() -> void:
#	var cells: Array = $YSort/Foreground.get_used_cells()
#	print(cells)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click_left"):
		var instance: Node2D = spawn_bug.instance()
		instance.position = event.position
		map.add_child(instance)
