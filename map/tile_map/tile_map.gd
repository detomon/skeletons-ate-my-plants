extends TileMap

export var plant_frame: = 0 setget set_plant_frame
func set_plant_frame(value: int) -> void:
	plant_frame = value
	if plant_material:
		plant_material.set_shader_param("frame", plant_frame)

var plant_material: ShaderMaterial

func _ready() -> void:
	var plant_tile: = tile_set.find_tile_by_name("plant")
	plant_material = tile_set.tile_get_material(plant_tile)
	set_plant_frame(plant_frame)
