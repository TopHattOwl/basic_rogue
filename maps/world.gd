extends Node2D

# This Node is instanced when entering a map tile that is not premade and not generated yet
# a copy of this node is made and set as current map
# when exiting data about the map is saved

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
var current_map_pos = Vector2i(0, 0)
var savagery: int = 0
var civilization: bool = false
var biome: int = 0
var monster_data: Dictionary = {}

func init_data(d: Dictionary) -> void:

	terrain_data = d.get("terrain_data", null)
	tilesets = d.get("tile_sets", tilesets)
	current_map_pos = d.get("world_map_pos", Vector2i(0, 0))
	savagery = d.get("savagery", 0)
	civilization = d.get("civilization", false)
	biome = d.get("biome_type", 0)
	monster_data = d.get("monster_data", {})

	print(tilesets)

	if !MapFunction.is_in_world_map(current_map_pos):
		push_error("Tile is not in world map")
		return
	# set TileMapLayer Nodes' tilesets
	floor_layer.tile_set = tilesets[GameData.TILE_TAGS.FLOOR]
	stair_layer.tile_set = tilesets[GameData.TILE_TAGS.STAIR]
	door_layer.tile_set = tilesets[GameData.TILE_TAGS.DOOR]
	door_frame_layer.tile_set = tilesets[GameData.TILE_TAGS.DOOR_FRAME]
	nature_layer.tile_set = tilesets[GameData.TILE_TAGS.NATURE]
	wall_layer.tile_set = tilesets[GameData.TILE_TAGS.WALL]


func generate_terrain_data() -> void:
	pass


func _ready() -> void:
	# draw the map
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			var atlas_max = TileSetDrawData[biome][GameData.TILE_TAGS.FLOOR]["atlas_coords_max"]
			var atlas_min = TileSetDrawData[biome][GameData.TILE_TAGS.FLOOR]["atlas_coords_min"]
			var source_id = TileSetDrawData[biome][GameData.TILE_TAGS.FLOOR].source_id
			floor_layer.set_cell(Vector2i(x, y), source_id, Vector2i(randi_range(atlas_min.x, atlas_max.x), randi_range(atlas_min.y, atlas_max.y)))


# tile set's draw data
var TileSetDrawData = {
	GameData.WORLD_TILE_TYPES.SWAMP: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), 
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
			"source_id": 0,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(0, 0),
		},
	},
	GameData.WORLD_TILE_TYPES.FIELD: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), 
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
			"source_id": 0,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(0, 0),
		},
	},
	GameData.WORLD_TILE_TYPES.DESERT: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), 
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
			"source_id": 0,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(0, 0),
		},
	},
	GameData.WORLD_TILE_TYPES.MOUNTAIN: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), 
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
			"source_id": 0,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(0, 0),
		},
	},
	GameData.WORLD_TILE_TYPES.FOREST: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": 0,
			"atlas_coords_max": Vector2i(1, 2), 
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
			"source_id": 0,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(0, 0),
		},
	},
}
