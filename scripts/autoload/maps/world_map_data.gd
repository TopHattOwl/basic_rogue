extends Node
# one tile in world map is a screen if entered
# world_map will hold data about a world map tile ()
var world_map = []

# biome types is a 2d array correspondng to each world map tile's biome type
var biome_type = []

# world_map_monster_data is a 2d array holding data about monsters spawning in each world map tile
var world_map_monster_data = []

# world_map_identity is a 2d array holding info about each world map tile
var world_map_identity = []

# 2d array corresponding to world map tile's savagery rate (0-14) 0 -> no chance for monsters
var world_map_savagery = []

# 2d array corresponding to world map tile's civilization 1 -> civilization 0 -> not civilization
var world_map_civilization = []

# var tile_template = {
#	 "is_premade": false,
#	 "map_path": "",
#	 "generated_seed": 0,
#	 "explored": false,
#	 "walkable": false,
# }

# biome types is a 2d array correspondng to each world map tile's biome type -> biome_type[y][x] tells what biome the tile is
# var biome_type_template = {
# 	"biome_type": int, # int from enum WORLD_TILE_TYPES
# }

# world_map_monster_data is a 2d array holding data about monsters spawning in each world map tile
# everything is null, it all gets filled in and saved when map is generated
# var world_map_monster_data_template = {
# 	"monster_types": Array, # array of int from enum MONSTER_TYPES, there monsters can appear here
# 	"spawn_points": Array, # array of Vector2i, gets filled in when map is generated and saved
#	"has_dungeon": bool,
# }


# var world_map_identity_template = {
# 	"name": string,
#	"notes": Array, array of strings for notes
# }


func _ready() -> void:
	SaveFuncs.load_world_map_data()

	parse_world_map_data()

	# set world map civilization since it gets it from biome only (and it's loaded already here)
	init_world_map_civilization()

	# init_world_map_data()
	# init_biome_type()
	# init_world_map_monster_data()
	# init_world_map_savagery()

	# # add first outpost
	# add_map_to_world_map(Vector2i(5, 8), DirectoryPaths.first_outpost, 0, true)

	# # add field with hideout
	# add_map_to_world_map(Vector2i(5, 9), DirectoryPaths.field_with_hideout, 0, true)

	# SaveFuncs.save_world_map_data()

# --- ADD MAP ---
func add_map_to_world_map(world_map_pos: Vector2i, map_path: String = "", generated_seed: int = 0, explored: int = 0, walkable: int = 1) -> void:
	if map_path:
		world_map[world_map_pos.y][world_map_pos.x] = {
			"is_premade": true,
			"map_path": map_path,
			"generated_seed": generated_seed,
			"explored": explored,
			"walkable": walkable
		}
	else:
		world_map[world_map_pos.y][world_map_pos.x] = {
			"is_premade": false,
			"map_path": map_path,
			"generated_seed": generated_seed,
			"explored": explored,
			"walkable": walkable
		}

# --- INIT ---
func init_world_map_data() -> void:
	world_map = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		world_map.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			world_map[y].append({
				"is_premade": false,
				"map_path": "",
				"generated_seed": randi_range(111111, 999999),
				"explored": 0,
				"walkable": 1
			})

func init_biome_type() -> void:
	biome_type = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		biome_type.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			biome_type[y].append(0)

func init_world_map_monster_data() -> void:
	world_map_monster_data = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		world_map_monster_data.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			world_map_monster_data[y].append({
				"monster_types": [],
				"spawn_points": [],
				"has_dungeon": false,
		})

func init_world_map_savagery() -> void:
	world_map_savagery = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		world_map_savagery.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			world_map_savagery[y].append(0)

# 
func init_world_map_civilization() -> void:
	world_map_civilization = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		world_map_civilization.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			if is_tile_civilization(Vector2i(x, y)):
				world_map_civilization[y].append(1)
			else:
				world_map_civilization[y].append(0)


# --- PARSING ---
# if it has water no other tile can be there

## parses world map data from world_map Node
## depending on the position and map type assigns biome type, monsters and such
func parse_world_map_data() -> void:
	
	# get world map scene
	var world_map_scene = load(DirectoryPaths.world_map_scene).instantiate()

	# set biome type
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)
			
			# if water then no other tile can be there
			var water_layer = world_map_scene.get_node(GameData.WorldMapTileLayer[GameData.WORLD_TILE_TYPES.WATER])
			if water_layer and water_layer.get_cell_tile_data(grid_pos):
				biome_type[y][x] = GameData.WORLD_TILE_TYPES.WATER
				continue

			var field_layer = world_map_scene.get_node(GameData.WorldMapTileLayer[GameData.WORLD_TILE_TYPES.FIELD])
			if field_layer and field_layer.get_cell_tile_data(grid_pos):
				biome_type[y][x] = GameData.WORLD_TILE_TYPES.FIELD
				continue
			
			var forest_layer = world_map_scene.get_node(GameData.WorldMapTileLayer[GameData.WORLD_TILE_TYPES.FOREST])
			if forest_layer and forest_layer.get_cell_tile_data(grid_pos):
				biome_type[y][x] = GameData.WORLD_TILE_TYPES.FOREST
				continue
			
			var mountain_layer = world_map_scene.get_node(GameData.WorldMapTileLayer[GameData.WORLD_TILE_TYPES.MOUNTAIN])
			if mountain_layer and mountain_layer.get_cell_tile_data(grid_pos):
				biome_type[y][x] = GameData.WORLD_TILE_TYPES.MOUNTAIN
				continue
			
			var desert_layer = world_map_scene.get_node(GameData.WorldMapTileLayer[GameData.WORLD_TILE_TYPES.DESERT])
			if desert_layer and desert_layer.get_cell_tile_data(grid_pos):
				biome_type[y][x] = GameData.WORLD_TILE_TYPES.DESERT
				continue
			
			var outpost_layer = world_map_scene.get_node(GameData.WorldMapTileLayer[GameData.WORLD_TILE_TYPES.OUTPOST])
			if outpost_layer and outpost_layer.get_cell_tile_data(grid_pos):
				biome_type[y][x] = GameData.WORLD_TILE_TYPES.OUTPOST
				continue
	

	# get savagery rate
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			# TODO: get closest civilization -> distance from it = savagery_rate
			pass


# --- CHECKS ---

func is_tile_civilization(grid_pos: Vector2i) -> bool:
	match biome_type[grid_pos.y][grid_pos.x]:
		GameData.WORLD_TILE_TYPES.CITY:
			return true
		GameData.WORLD_TILE_TYPES.VILLAGE:
			return true
		GameData.WORLD_TILE_TYPES.OUTPOST:
			return true

	return false