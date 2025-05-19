class_name MountainBiome
extends Resource

@export var biome_type: int
@export var biome_name: String
@export var grid_pos: Vector2i

# load data into world Node here and set variables

func _init(pos: Vector2i = Vector2i.ZERO) -> void:
	pass

func setup(pos: Vector2i = Vector2i.ZERO) -> void:
	biome_type = GameData.WORLD_TILE_TYPES.MOUNTAIN
	biome_name = "Mountain"
	grid_pos = pos

func load():
	pass

func generate():
	pass

func render():
	pass



var tileset_resource =  {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "res://resources/tiles/biome_sets/field/field_stair_tileset.tres",
		GameData.TILE_TAGS.DOOR: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.DOOR_FRAME: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.NATURE: "res://resources/tiles/biome_sets/field/field_nature_tileset.tres",
		GameData.TILE_TAGS.WALL: "res://resources/tiles/biome_sets/field/field_wall_tileset.tres",
	}

var tile_set_draw_data ={
	GameData.TILE_TAGS.FLOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.WALL: {
		"source_id": 1,
		"atlas_coords_max": Vector2i(0, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.STAIR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.DOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(0, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.DOOR_FRAME: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 0), 
		"atlas_coords_min": Vector2i(1, 0),
	},
	GameData.TILE_TAGS.NATURE: {
		"source_id": 2,
		"atlas_coords_max": Vector2i(0, 0), 
		"atlas_coords_min": Vector2i(1, 0),
	},
}
