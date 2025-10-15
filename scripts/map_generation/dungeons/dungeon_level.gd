class_name DungeonLevel
extends Resource

@export var level: int # starting from 0
@export var terrain_map: Array
@export var stair_up: DungeonStair
@export var stair_down: DungeonStair

var rng: RandomNumberGenerator
@export var rng_seed: int:
	set(value):
		rng = RandomNumberGenerator.new()
		rng.seed = value

# explored toles for FOV
@export var explored_tiles: Array[Vector2i] = []

@export var world_map_pos: Vector2i


func _init(data: Dictionary = {}) -> void:
	pass


func generate_dugeon_level(_level: int, _world_map_pos: Vector2i) -> void:
	rng = RandomNumberGenerator.new()
	rng_seed = (_level + 1) * (_world_map_pos.x + 1) + (_world_map_pos.y + 1)
	rng.seed = rng_seed
	level = _level
	world_map_pos = _world_map_pos

	# overriden in child classes
	generate_level_terrain()


## overriden in child classes
func generate_level_terrain() -> void:
	pass


func place_stair(pos: Vector2i, is_up: bool, spawn_pos: Vector2i) -> void:
	# Replace wall with stair

	# replace wall at position with floor
	terrain_map[pos.y][pos.x] = {
		"tags": [GameData.TILE_TAGS.FLOOR],
		"walkable": true,
		"transparent": true,
	}

	add_terrain_map_data(pos, GameData.TILE_TAGS.STAIR)

	# add stair

	var stair = DungeonStair.new({
		"is_up": is_up,
		"pos": pos,
		"depth": level,
		"spawn_pos": spawn_pos
	})

	if is_up:
		stair_up = stair
	else:
		stair_down = stair



func has_floor_neighbor(pos: Vector2i, num_of_neighbors: int = 1) -> bool:
	# Check 4-directional neighbors for floor
	var neighbors = [
		# othogonal
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x - 1, pos.y), 
		Vector2i(pos.x, pos.y + 1),
		Vector2i(pos.x, pos.y - 1),

		# diagonal
		Vector2i(pos.x + 1, pos.y + 1),
		Vector2i(pos.x - 1, pos.y - 1), 
		Vector2i(pos.x - 1, pos.y + 1),
		Vector2i(pos.x + 1, pos.y - 1),

	]
	
	var floor_count = 0
	for neighbor in neighbors:
		if not MapFunction.is_in_bounds(neighbor):
			continue
		var tile = terrain_map[neighbor.y][neighbor.x]
		if tile["tags"].has(GameData.TILE_TAGS.FLOOR) and not is_wall(neighbor):
			floor_count += 1
	
	return floor_count >= num_of_neighbors

## finds spawn pos for stair 
func find_stair_spawn_position(stair_pos: Vector2i) -> Vector2i:
	# Look for floor tiles in the 8 surrounding positions
	var floor_candidates = []
	
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 and y == 0:
				continue  # Skip the stair position itself
			
			var check_pos = Vector2i(stair_pos.x + x, stair_pos.y + y)
			
			# Check bounds
			if not MapFunction.is_in_bounds(check_pos):
				continue
			
			var tile = terrain_map[check_pos.y][check_pos.x]
			if tile["tags"].has(GameData.TILE_TAGS.FLOOR) and tile["walkable"]:
				floor_candidates.append(check_pos)
	
	# If we found floor tiles, pick one
	if floor_candidates.size() > 0:
		# maybe add logic here to prefer more 'open' spaces
		return floor_candidates[0]
	else:
		push_warning("No floor tile found near stair at " + str(stair_pos) + ", using stair position as fallback")
		return stair_pos

func find_farthest_stair_position(candidates: Array, reference_pos: Vector2i) -> Vector2i:
	var farthest_pos = candidates[0]
	var max_distance = 0
	
	for candidate in candidates:
		var distance = abs(candidate.x - reference_pos.x) + abs(candidate.y - reference_pos.y)  # Manhattan distance
		if distance > max_distance:
			max_distance = distance
			farthest_pos = candidate
	
	return farthest_pos

func is_wall(pos: Vector2i) -> bool:
	return terrain_map[pos.y][pos.x]["tags"].has(GameData.TILE_TAGS.WALL)


func count_neighboring_walls(grid_pos: Vector2i, grid: Array) -> int:

	var count = 0
	var x = grid_pos.x
	var y = grid_pos.y

	var max_x = GameData.MAP_SIZE.x - 1
	var max_y = GameData.MAP_SIZE.y - 1

	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue
			var nx = x + i
			var ny = y + j
			
			# use combined bounds check
			if nx >= 0 and nx <= max_x and ny >= 0 and ny <= max_y:
				if grid[ny][nx]:
					count += 1
			else:
				# count out-of-bounds as walls
				count += 1
	return count


func add_terrain_map_data(target_pos: Vector2i, tile_tag: int) -> void:

	var target_tile = terrain_map[target_pos.y][target_pos.x]
	var tile_data = GameData.get_tile_data(tile_tag)

	if target_tile["tags"].has(tile_tag):
		return
	target_tile["tags"].append(tile_tag)

	# apply most restrictive properties
	target_tile["walkable"] = target_tile["walkable"] and tile_data.walkable
	target_tile["transparent"] = target_tile["transparent"] and tile_data.transparent

## resets terrain map data to floor for the given position
func reset_terrain_map_data(target_pos: Vector2i) -> void:

	var target_tile = terrain_map[target_pos.y][target_pos.x]

	target_tile["tags"] = [GameData.TILE_TAGS.FLOOR]
	target_tile["walkable"] = true
	target_tile["transparent"] = true



## saves exlored tiles for map [br]
## only saves it to the varable, does not write save file
func save_explored_tiles(tiles: Array) -> void:
	explored_tiles = tiles


func get_explored_tiles() -> Array:
	return explored_tiles.duplicate()