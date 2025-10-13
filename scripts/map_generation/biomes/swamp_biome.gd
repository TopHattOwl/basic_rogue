class_name SwampBiome
extends Biome


# load data into world Node here and set variables

func _init(_pos: Vector2i = Vector2i.ZERO) -> void:
	pass

func setup(pos: Vector2i = Vector2i.ZERO) -> void:
	biome_type = GameData.WORLD_TILE_TYPES.SWAMP
	biome_name = "Swamp"
	grid_pos = pos
	
	tileset_resource =  DrawDatas.biome_tileset_resource[GameData.WORLD_TILE_TYPES.SWAMP]
	tile_set_draw_data = DrawDatas.biome_tileset_draw_data[GameData.WORLD_TILE_TYPES.SWAMP]

	wall_chance = 0.001
	nature_chance = 0.1

