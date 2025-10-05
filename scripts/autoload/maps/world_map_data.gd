extends Node

# one tile in world map is a screen if entered
# world_map will hold data about a world map tile
var world_map2 = WorldMap.new()

# biome types is a 2d array correspondng to each world map tile's biome type using enum WORLD_TILE_TYPES, all biome are here, even premade ones
var biome_type = []

# 2d array filled with Biome objects, filled in after biome_type, used for generation only,
# if biome type is premade type (like village, city, etc) then biome_map's value will be null
var biome_map = BiomeMap.new()

var world_monster_map = WorldMonsterMap.new()

# world_map_identity is a 2d array holding info about each world map tile
var world_map_identity = []

# 2d array corresponding to world map tile's savagery rate (0-14) 0 -> no chance for monsters
var world_map_savagery = [] # effects monster spawn rate and dungeon spawns chance

# 2d array corresponding to world map tile's civilization 1 -> civilization 0 -> not civilization
var world_map_civilization = []


var settlements := SettlementsMap.new()

var dungeons := DungeonMap.new()


func _ready() -> void:
	SaveFuncs.load_base_world_map_data()

	# set_base()
	

## THIS SHOULD ONLY RUN IF WROLD MAP NODE HAS BEEN CHANGED (otherwise just load in base data)
## initializes the world map and saves it to base data
## used to set up base world map saves
## later when world map is fully thought out (how it looks like) this can be removed and world data loaded in from base
func set_base() -> void:

	init_biome_type()
	init_world_map_civilization()
	init_world_map_savagery()
	# custom classes (BiomeMap WorldMap etc gets initialized automatically when creating them (WorldMap.new() -> dont have to do it here)

	parse_world_map_data()

	SaveFuncs.save_base_world_map_data()


func get_biome_type(world_pos: Vector2i) -> int:
	if world_pos.x < 0 or world_pos.x >= GameData.WORLD_MAP_SIZE.x or world_pos.y < 0 or world_pos.y >= GameData.WORLD_MAP_SIZE.y:
		return -1
	return biome_type[world_pos.y][world_pos.x]

# --- INIT ---

func init_biome_type() -> void:
	biome_type = []
	for y in range(GameData.WORLD_MAP_SIZE.y):
		biome_type.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			biome_type[y].append(0)

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
			world_map_civilization[y].append(0)

# --- PARSING ---
# if it has water no other tile can be there

## parses world map data from world_map Node
## depending on the position and map type assigns biome type, monsters and such
func parse_world_map_data() -> void:
	
	# get world map scene
	var world_map_scene = load(DirectoryPaths.world_map_scene).instantiate()
	
	parse_biome_type(world_map_scene)

	parse_biome(world_map_scene)

	parse_civilization()

	parse_savagery()

	parse_monster_data()
	

func parse_biome_type(world_map_scene: Node2D) -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)

			for key in GameData.WorldMapTileLayer.keys():
				var layer = world_map_scene.get_node(GameData.WorldMapTileLayer[key])
				if layer and layer.get_cell_tile_data(grid_pos):
					biome_type[y][x] = key
					if key == GameData.WORLD_TILE_TYPES.WATER:
						world_map2.map_data[y][x].walkable = false
					break

func parse_biome(world_map_scene: Node2D) -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)

			for key in GameData.WorldMapTileLayer.keys():
				var layer = world_map_scene.get_node(GameData.WorldMapTileLayer[key])
				if layer and layer.get_cell_tile_data(grid_pos):

					match key:
						GameData.WORLD_TILE_TYPES.FIELD:
							var biome = FieldBiome.new()
							biome.setup(Vector2i(x, y))
							biome_map.map_data[y][x] = biome
						GameData.WORLD_TILE_TYPES.FOREST:
							var biome = ForestBiome.new()
							biome.setup(Vector2i(x, y))
							biome_map.map_data[y][x] = biome
						GameData.WORLD_TILE_TYPES.DESERT:
							var biome = DesertBiome.new()
							biome.setup(Vector2i(x, y))
							biome_map.map_data[y][x] = biome
						GameData.WORLD_TILE_TYPES.MOUNTAIN:
							var biome = MountainBiome.new()
							biome.setup(Vector2i(x, y))
							biome_map.map_data[y][x] = biome
						GameData.WORLD_TILE_TYPES.SWAMP:
							var biome = SwampBiome.new()
							biome.setup(Vector2i(x, y))
							biome_map.map_data[y][x] = biome
						_:
							# if biome type is premade/water -> tile's biome is null
							biome_map.map_data[y][x] = null

					# set biome type for all tiles
					biome_type[y][x] = key


					if key == GameData.WORLD_TILE_TYPES.WATER:
						world_map2.map_data[y][x].walkable = false
					break
		

func parse_monster_data() -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)

			# var tier = calc_monster_tier(grid_pos)
			var biome = biome_type[y][x]

			# if biome type does not upport monster spawning -> skip
			if not GameData.HostileBiomes.has(biome):
				continue

			world_monster_map.map_data[y][x] = WorldMonsterTile.new(grid_pos)

func parse_civilization() -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
			if is_tile_civilization(Vector2i(x, y)):
				world_map_civilization[y][x] = 1

func parse_savagery() -> void:
	for y in range(GameData.WORLD_MAP_SIZE.y):
		for x in range(GameData.WORLD_MAP_SIZE.x):
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
