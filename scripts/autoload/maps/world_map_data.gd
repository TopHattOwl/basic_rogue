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
var world_map_savagery = [] # effects monster spawn rate and dungeon spawns chance

# 2d array corresponding to world map tile's civilization 1 -> civilization 0 -> not civilization, set when world map is loaded
var world_map_civilization = []

# var tile_template = {
#	 "is_premade": false,
#	 "map_path": "",
#	 "generated_seed": 0,
#	 "explored": false,
#	 "walkable": false, # is it walkable on world map
# }

# biome types is a 2d array correspondng to each world map tile's biome type -> biome_type[y][x] = int tells what biome the tile is
# var biome_type_template = [
# 	int, # int from enum WORLD_TILE_TYPES
# ]

# world_map_monster_data is a 2d array holding data about monsters spawning in each world map tile
# everything is null, it all gets filled in and saved when map is generated
# var world_map_monster_data_template = {
#	"monster_tier": int, from 1 to 5
# 	"monster_types": Array, # array of int from enum MONSTERS_ALL, what monsters can appear here
# 	"spawn_points": Array, # array of Vector2i, gets filled in when map is generated and saved
#	"has_dungeon": bool,
# }


# var world_map_identity_template = {
# 	"name": string,
#	"notes": Array, array of strings for notes
# }


func _ready() -> void:
	SaveFuncs.load_world_map_data()

	# parse_world_map_data()

	
	# init_world_map_civilization()
	# init_world_map_data()
	# init_biome_type()
	# init_world_map_monster_data()
	# init_world_map_savagery()

	# # add first outpost
	# add_map_to_world_map(Vector2i(31, 16), DirectoryPaths.first_outpost, 0, true)

	# # add field with hideout
	# add_map_to_world_map(Vector2i(31, 17), DirectoryPaths.field_with_hideout, 0, true)

	# reset_world_map_tile(Vector2i(5, 8))
	# reset_world_map_tile(Vector2i(31, 17))

	# SaveFuncs.save_world_map_data()

# --- MAP DATA REGISTRY ---
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

func reset_world_map_tile(grid_pos: Vector2i) -> void:
	if !MapFunction.is_in_world_map(grid_pos):
		push_error("tile is not in world map")
		return

	world_map[grid_pos.y][grid_pos.x] = {
		"is_premade": false,
		"map_path": "",
		"generated_seed": randi_range(111111, 999999),
		"explored": 0,
		"walkable": 1
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
				"monster_tier": 0,
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
	# parse_biome_type(world_map_scene)

	# set monster data
	# parse_monster_data()

	# set savagery rate, savagery is saved so this need to run only once
	# parse_savagery()
	

func parse_biome_type(world_map_scene: Node2D) -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)

			for key in GameData.WorldMapTileLayer.keys():
				var layer = world_map_scene.get_node(GameData.WorldMapTileLayer[key])
				if layer and layer.get_cell_tile_data(grid_pos):
					biome_type[y][x] = key
					if key == GameData.WORLD_TILE_TYPES.WATER:
						world_map[y][x].walkable = 0
					break

# func parse_monster_data() -> void:
# 	for y in range(GameData.WORLD_MAP_SIZE.y):
# 		for x in range(GameData.WORLD_MAP_SIZE.x):
# 			var grid_pos = Vector2i(x, y)

# 			var tier = calc_monster_tier(grid_pos)
# 			var biome = biome_type[y][x]

# 			# if biome type does not upport monster spawning -> skip
# 			if !GameData.MonstersAll[tier].has(biome):
# 				continue

# 			var types = GameData.MonstersAll[tier][biome_type[y][x]]
# 			world_map_monster_data[y][x] = {
# 				"monster_tier": tier,
# 				"monster_types": types,
# 				"spawn_points": [], # gets filled when map is generated
# 				"has_dungeon": false # also gets filled when generated
# 			}




func parse_savagery() -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			# TODO: get closest civilization -> distance from it = savagery_rate
			world_map_savagery[y][x] = calc_savagery_for_tile(Vector2i(x, y))

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


# --- UTILS ---

## returns wotld map tile's savagery rate depen on distance from civlization
# TODO: outposts start at 4 savagery, city -> 0, village -> 2
func calc_savagery_for_tile(grid_pos: Vector2i) -> int:

	var distance = 15

	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			if world_map_civilization[y][x]:
				var current_distance = MapFunction.manhattan_distance(grid_pos, Vector2i(x, y))
				distance = current_distance if current_distance < distance else distance
	return distance


func calc_monster_tier(grid_pos: Vector2i) -> int:

	var savagery = world_map_savagery[grid_pos.y][grid_pos.x]
	
	var tier = savagery / 3
	tier = tier if tier > 0 else 1

	return tier
