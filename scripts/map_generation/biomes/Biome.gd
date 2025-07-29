class_name Biome
extends Resource


var biome_type: int
var biome_name: String
var grid_pos: Vector2i

var terrain_map: Array

var map_rng = RandomNumberGenerator.new()


func setup(pos: Vector2i = Vector2i.ZERO) -> void:
	biome_type = GameData.WORLD_TILE_TYPES.FIELD
	biome_name = "Field"
	grid_pos = pos