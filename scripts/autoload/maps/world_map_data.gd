extends Node
# one tile in world map is a screen if entered
# world_map will hold data about a world map tile ()
var world_map = []


# biome types is a 2d array correspondng to each world map tile's biome type
var biome_type = []


# world_map_monster_data is a 2d array holding data about monsters spawning in each world map tile
var world_map_monster_data = []

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
# }


func _ready() -> void:
	# SaveFuncs.load_world_map_data()

	init_world_map_data()
	init_biome_type()
	init_world_map_monster_data()

	# add first outpost
	add_map_to_world_map(Vector2i(5, 8), DirectoryPaths.first_outpost, 0, true)

	# add field with hideout
	add_map_to_world_map(Vector2i(5, 9), DirectoryPaths.field_with_hideout, 0, true)

	SaveFuncs.save_world_map_data()


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


func init_world_map_data() -> void:
	world_map = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		world_map.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			world_map[y].append({
				"is_premade": false,
				"map_path": "",
				"generated_seed": 0,
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
		})
