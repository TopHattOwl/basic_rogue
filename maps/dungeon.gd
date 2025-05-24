extends Node2D


@export var floor_layer: TileMapLayer
@export var stair_layer: TileMapLayer
@export var door_layer: TileMapLayer
@export var door_frame_layer: TileMapLayer
@export var nature_layer: TileMapLayer
@export var wall_layer: TileMapLayer


var tilesets = {
	GameData.TILE_TAGS.FLOOR: null,
	GameData.TILE_TAGS.STAIR: null,
	GameData.TILE_TAGS.DOOR: null,
	GameData.TILE_TAGS.DOOR_FRAME: null,
	GameData.TILE_TAGS.NATURE: null,
	GameData.TILE_TAGS.WALL: null
}

var terrain_data = null

var dungeon_level_size: Vector2i = Vector2i.ZERO

var tile_set_draw_data = {}

var map_rng: RandomNumberGenerator


func init_data(d: Dictionary) -> void:
	terrain_data = d.get("terrain_map", MapFunction.make_base_terrain_map())
	dungeon_level_size = d.get("dungeon_level_size", Vector2i.ZERO)
	tilesets = d.get("tile_sets", tilesets)
	tile_set_draw_data = d.get("tile_set_draw_data", {})
	map_rng = d.get("rng", RandomNumberGenerator.new())


	floor_layer.tile_set = load(tilesets[GameData.TILE_TAGS.FLOOR])
	stair_layer.tile_set = load(tilesets[GameData.TILE_TAGS.STAIR])
	door_layer.tile_set = load(tilesets[GameData.TILE_TAGS.DOOR])
	door_frame_layer.tile_set = load(tilesets[GameData.TILE_TAGS.DOOR_FRAME])
	nature_layer.tile_set = load(tilesets[GameData.TILE_TAGS.NATURE])
	wall_layer.tile_set = load(tilesets[GameData.TILE_TAGS.WALL])



func _ready() -> void:

	# draw the map
	for y in range(dungeon_level_size.y):
		for x in range(dungeon_level_size.x):
			var atlas_max = tile_set_draw_data[GameData.TILE_TAGS.FLOOR]["atlas_coords_max"]
			var atlas_min = tile_set_draw_data[GameData.TILE_TAGS.FLOOR]["atlas_coords_min"]
			var source_id = tile_set_draw_data[GameData.TILE_TAGS.FLOOR].source_id
			floor_layer.set_cell(Vector2i(x, y), source_id, Vector2i(map_rng.randi_range(atlas_min.x, atlas_max.x), map_rng.randi_range(atlas_min.y, atlas_max.y)))

			if terrain_data[y][x]["tags"].has(GameData.TILE_TAGS.WALL):
				var wall_source_id = tile_set_draw_data[GameData.TILE_TAGS.WALL].source_id
				wall_layer.set_cell(Vector2i(x, y), wall_source_id, Vector2i(0, 0))
