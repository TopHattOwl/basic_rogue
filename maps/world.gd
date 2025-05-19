extends Node2D

# variable set order:
	# init_data called from map_generator.gd
	# generate_terrain_data() called from map_generator.gd (this adds monsters and terrain data)
	# GameData variables set in map_generator.gd
	# here in ready() map is drawn and GameData.terrain_map is set
	# changed WorldMapData variables are set here

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

# rng machine
var map_rng = RandomNumberGenerator.new()

func init_data(d: Dictionary) -> void:

	# terrain data here is filled with floor tiles only, other layers added here
	terrain_data = d.get("terrain_data", MapFunction.make_base_terrain_map())
	tilesets = d.get("tile_sets", tilesets)
	current_map_pos = d.get("world_map_pos", Vector2i(0, 0))
	savagery = d.get("savagery", 0)
	civilization = d.get("civilization", false)
	biome = d.get("biome_type", 0)
	monster_data = d.get("monster_data", {})

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

	# set rng machine
	map_rng.seed = WorldMapData.world_map2.map_data[current_map_pos.y][current_map_pos.x].generated_seed

# generation gets called in map_generator.gd if something is not generated
func generate_terrain_data() -> void:
	match biome:
		GameData.WORLD_TILE_TYPES.FIELD:
			generate_field_terrain()
		GameData.WORLD_TILE_TYPES.FOREST:
			generate_forest_terrain()

# gets called when entering a map tile that is explored, so data gets loaded
func load_data() -> void:
	
	pass

func _ready() -> void:


	# draw the map
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			var atlas_max = TileSetDrawData[biome][GameData.TILE_TAGS.FLOOR]["atlas_coords_max"]
			var atlas_min = TileSetDrawData[biome][GameData.TILE_TAGS.FLOOR]["atlas_coords_min"]
			var source_id = TileSetDrawData[biome][GameData.TILE_TAGS.FLOOR].source_id
			floor_layer.set_cell(Vector2i(x, y), source_id, Vector2i(map_rng.randi_range(atlas_min.x, atlas_max.x), map_rng.randi_range(atlas_min.y, atlas_max.y)))

			if terrain_data[y][x]["tags"].has(GameData.TILE_TAGS.WALL):
				var wall_source_id = TileSetDrawData[biome][GameData.TILE_TAGS.WALL].source_id
				wall_layer.set_cell(Vector2i(x, y), wall_source_id, Vector2i(0, 0))
			if terrain_data[y][x]["tags"].has(GameData.TILE_TAGS.NATURE):
				var nature_source_id = TileSetDrawData[biome][GameData.TILE_TAGS.NATURE].source_id
				var selected_tree = Vector2i(0, 0) if map_rng.randf() < 0.8 else Vector2i(1, 0)
				nature_layer.set_cell(Vector2i(x, y), nature_source_id, selected_tree)
	

	# spawn monsters
	if monster_data.spawn_points.size() > 0:
		for spawn_point in monster_data.spawn_points:
			EntitySystems.entity_spawner.spawn_monster(spawn_point, monster_data.monster_types[0])

	GameData.terrain_map = terrain_data
	set_world_map_data(current_map_pos)
	MapFunction.initialize_astar_grid()

#  --- GENERATORS ---

# --- Field
# variables
var field_wall_chance: float = 0.015
var field_nature_chance: float = 0.02
func generate_field_terrain() -> void:

	field_add_walls()
	field_add_nature()
	field_add_monsters()

func field_add_walls() -> void:
	# field has few walls (rocks, boulders)
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if x == 0 or x == GameData.MAP_SIZE.x - 1 or y == 0 or y == GameData.MAP_SIZE.y - 1:
				continue
			if map_rng.randf() < field_wall_chance:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL, GameData.get_tile_data(GameData.TILE_TAGS.WALL))
				 

func field_add_nature() -> void:
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if terrain_data[y][x].tags.has(GameData.TILE_TAGS.WALL):
				continue
			if map_rng.randf() < field_nature_chance:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.NATURE, GameData.get_tile_data(GameData.TILE_TAGS.NATURE))
			

func field_add_monsters() -> void:
	var max_monsters = max(0, savagery - 2)
	var num_of_monsters = 0
	
	while num_of_monsters < max_monsters:
		var random_pos = Vector2i(map_rng.randi_range(0, GameData.MAP_SIZE.x - 1), map_rng.randi_range(0, GameData.MAP_SIZE.y - 1))
		if terrain_data[random_pos.y][random_pos.x].tags.has(GameData.TILE_TAGS.WALL):
			continue
		monster_data.spawn_points.append(random_pos)
		num_of_monsters += 1
	print(monster_data)

	if savagery > 10:
		monster_data.has_dungeon = true
			
	
# --- Forest
func generate_forest_terrain() -> void:
	forest_add_walls()
	forest_add_nature()
	forest_add_monsters()

func forest_add_walls() -> void:
	pass
func forest_add_nature() -> void:
	pass
func forest_add_monsters() -> void:
	pass


# --- UTILS ---

## Adds terrain map data to this Nodes terrain data,
## To set GameData.terrain map use MapFunction.add_terrain_map_data()
func add_terrain_map_data(target_pos: Vector2i, tag: int, tile_info: Dictionary) -> void:
	var target_tile = terrain_data[target_pos.y][target_pos.x]
	target_tile["tags"].append(tag)

	# apply most restrictive properties
	target_tile["walkable"] = target_tile["walkable"] and tile_info.walkable
	target_tile["transparent"] = target_tile["transparent"] and tile_info.transparent

func set_world_map_data(target_pos: Vector2i) -> void:
	# explore
	WorldMapData.world_map2.map_data[target_pos.y][target_pos.x].explored = true

	# monster data
	WorldMapData.world_map_monster_data[target_pos.y][target_pos.x].spawn_points = monster_data.spawn_points
	WorldMapData.world_map_monster_data[target_pos.y][target_pos.x].has_dungeon = monster_data.has_dungeon

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
