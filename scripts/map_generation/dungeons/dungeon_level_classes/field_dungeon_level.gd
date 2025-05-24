class_name FieldDungeonLevel
extends Resource

# - **level**: int, the level of the dungeon (starting from 0)
# - **Map size**: Vector2i of the map size
# - **Terrain map**: terrain map for the Dungeon node to draw map
# - **Stair down pos**:: Vector2i, position of entrance leading further
# - **Stair up pos**: Vector2i, position of entrance leading back

@export var level: int # starting from 0
@export var map_size: Vector2i
@export var terrain_map: Array
@export var stair_down_pos: Vector2i
@export var stair_up_pos: Vector2i

# star positions example
# 1 1 1 1 1 1 1 1 1
# 1 1 1 1 S S 1 1 1
# 1 1 1 1 0 0 0 0 0

# 1 -> wall
# 0 -> floor
# S -> stair

# filled when generating, array of dictionaries
@export var spawn_points: Array 
# var spawn_point_template = {
#	 "pos": Vector2i,
#	 "monster_key": int 
# }

var world_map_pos: Vector2i

var monster_types: Array
var monster_tier: int

var biome_type: int

var rng = RandomNumberGenerator.new()

func generate_dugeon_level(_level: int, _world_map_pos: Vector2i, _monster_types: Array, _monster_tier: int) -> FieldDungeonLevel:

	rng.seed = WorldMapData.world_map2.map_data[world_map_pos.y][world_map_pos.x].generated_seed

	# setting variables
	level = _level
	world_map_pos = _world_map_pos
	monster_types = _monster_types
	monster_tier = _monster_tier

	map_size = calc_map_size()

	generate_level_terrain()

	return self


func generate_level_terrain() -> void:

	for y in range(map_size.y):
		terrain_map.append([])
		for x in range(map_size.x):
			terrain_map[y].append({
				"tags": [GameData.TILE_TAGS.FLOOR],
				"walkable": true,
				"transparent": true
			})

	for y in map_size.y:
		for x in map_size.x:
			if y == 0 || y == map_size.y - 1 || x == 0 || x == map_size.x - 1:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL)

	add_walls()
	add_nature()
	add_forage()
	add_decal()
	add_monsters()
	


# make the walls with cellural automata
const NUM_OF_ITERATIONS = 3
func add_walls() -> void:
	# make cellural grid
	var grid = []
	for y in range(map_size.y):
		grid.append([])
		for x in range(map_size.x):
			grid[y].append(randf() < 0.45)

	
	for i in range(NUM_OF_ITERATIONS):
		var new_grid = grid.duplicate(true)
		for y in range(map_size.y):
			for x in range(map_size.x):
				var neighbors = count_neighboring_walls(Vector2i(x, y), grid)
				if grid[y][x]:
					new_grid[y][x] = neighbors > 3
				else:
					new_grid[y][x] = neighbors > 4
		grid = new_grid

	# use cellural grid to set walls

	for y in range(map_size.y):
		for x in range(map_size.x):
			if grid[y][x]:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL)


func add_nature() -> void:
	pass
func add_forage() -> void:
	pass
func add_decal() -> void:
	pass
func add_monsters() -> void:
	pass

# --- Utils ---

func calc_map_size() -> Vector2i:

	var _map_size := Vector2i.ZERO

	var savagery = WorldMapData.world_map_savagery[world_map_pos.y][world_map_pos.x]

	var x = GameData.MAP_SIZE.x / 2 + savagery * 3
	var y = GameData.MAP_SIZE.y / 2 + savagery * 2

	_map_size = Vector2i(x, y)

	return _map_size


func add_terrain_map_data(target_pos: Vector2i, tile_tag: int) -> void:

	var target_tile = terrain_map[target_pos.y][target_pos.x]
	var tile_data = GameData.get_tile_data(tile_tag)

	if target_tile["tags"].has(tile_tag):
		return
	target_tile["tags"].append(tile_tag)

	# apply most restrictive properties
	target_tile["walkable"] = target_tile["walkable"] and tile_data.walkable
	target_tile["transparent"] = target_tile["transparent"] and tile_data.transparent


func count_neighboring_walls(grid_pos: Vector2i, grid: Array) -> int:

	var count = 0

	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue  # Skip the center cell
			var nx = grid_pos.x + i
			var ny = grid_pos.y + j
			# Check if the neighboring cell is out of bounds
			if nx < 0 or nx >= map_size.x or ny < 0 or ny >= map_size.y:
				count += 1  # Count out-of-bounds as walls
			elif grid[ny][nx]:
				count += 1  # Count walls

	return count
