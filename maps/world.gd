class_name World
extends Node2D

# Tilemap Layers
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

# terrain data
var terrain_data = null

# world map data
# var current_map_pos = Vector2i(0, 0)
# var savagery: int = 0
# var civilization: bool = false
# var biome: int = 0
# var monster_data: Dictionary = {}

var monster_data_new: WorldMonsterTile

var tile_set_draw_data = {}

# rng machine
var map_rng: RandomNumberGenerator


## This is run in Biome classes when generating or loading a world
func init_data_new(d: Dictionary) -> void:
	terrain_data = d.get("terrain_map", MapFunction.make_base_terrain_map())
	# current_map_pos = d.get("pos", Vector2i(0, 0))
	tilesets = d.get("tile_sets", tilesets)
	monster_data_new = d.get("monster_data", {})
	tile_set_draw_data = d.get("tile_set_draw_data", {})
	map_rng = d.get("rng", RandomNumberGenerator.new())

	floor_layer.tile_set = load(tilesets[GameData.TILE_TAGS.FLOOR])
	stair_layer.tile_set = load(tilesets[GameData.TILE_TAGS.STAIR])
	door_layer.tile_set = load(tilesets[GameData.TILE_TAGS.DOOR])
	door_frame_layer.tile_set = load(tilesets[GameData.TILE_TAGS.DOOR_FRAME])
	nature_layer.tile_set = load(tilesets[GameData.TILE_TAGS.NATURE])
	wall_layer.tile_set = load(tilesets[GameData.TILE_TAGS.WALL])

func _ready() -> void:
	var is_dungeon_drawn = false
	# draw the map
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			var atlas_max = tile_set_draw_data[GameData.TILE_TAGS.FLOOR]["atlas_coords_max"]
			var atlas_min = tile_set_draw_data[GameData.TILE_TAGS.FLOOR]["atlas_coords_min"]
			var source_id = tile_set_draw_data[GameData.TILE_TAGS.FLOOR].source_id
			floor_layer.set_cell(Vector2i(x, y), source_id, Vector2i(map_rng.randi_range(atlas_min.x, atlas_max.x), map_rng.randi_range(atlas_min.y, atlas_max.y)))

			if terrain_data[y][x]["tags"].has(GameData.TILE_TAGS.WALL):
				var wall_source_id = tile_set_draw_data[GameData.TILE_TAGS.WALL].source_id
				wall_layer.set_cell(Vector2i(x, y), wall_source_id, Vector2i(0, 0))
			if terrain_data[y][x]["tags"].has(GameData.TILE_TAGS.NATURE):
				var nature_source_id = tile_set_draw_data[GameData.TILE_TAGS.NATURE].source_id
				var selected_tree = Vector2i(0, 0) if map_rng.randf() < 0.8 else Vector2i(1, 0)
				nature_layer.set_cell(Vector2i(x, y), nature_source_id, selected_tree)

	MapFunction.initialize_astar_grid()

	SignalBus.calculate_fov.emit()
	SignalBus.world_node_ready.emit()


## not used yet
func draw_stairs(pos: Vector2i) -> void:
	var source_id = tile_set_draw_data[GameData.TILE_TAGS.STAIR].source_id
	var atlas_max = tile_set_draw_data[GameData.TILE_TAGS.STAIR]["atlas_coords_max"]
	
	for x_offset in atlas_max.x + 1:
		for y_offset in atlas_max.y + 1:
			var current_grid_pos = Vector2i(pos.x + x_offset, pos.y + y_offset)
			var atlas_coords = Vector2i(x_offset, y_offset)

			stair_layer.set_cell(current_grid_pos, source_id, atlas_coords)
