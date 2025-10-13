class_name CaveDungeonLevel
extends DungeonLevel


func generate_level_terrain() -> void:

	for y in range(GameData.MAP_SIZE.y):
		terrain_map.append([])
		for x in range(GameData.MAP_SIZE.x):
			terrain_map[y].append({
				"tags": [GameData.TILE_TAGS.FLOOR],
				"walkable": true,
				"transparent": true
			})

	# border walls
	for y in GameData.MAP_SIZE.y:
		for x in GameData.MAP_SIZE.x:
			if y == 0 || y == GameData.MAP_SIZE.y - 1 || x == 0 || x == GameData.MAP_SIZE.x - 1:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL)

	add_walls()
	add_nature()
	add_forage()
	add_decal()
	add_stairs()


# make the walls with cellural automata
const NUM_OF_ITERATIONS = 4
func add_walls() -> void:
	# make cellural grid
	var grid = []
	for y in range(GameData.MAP_SIZE.y):
		grid.append([])
		for x in range(GameData.MAP_SIZE.x):
			grid[y].append(rng.randf() < 0.45)

	
	for i in range(NUM_OF_ITERATIONS):

		# make new grid
		var new_grid = []
		for y in range(GameData.MAP_SIZE.y):
			new_grid.append([])
			new_grid[y].resize(GameData.MAP_SIZE.x)


		# Process in batches - update new_grid based on grid
		for y in range(GameData.MAP_SIZE.y):
			for x in range(GameData.MAP_SIZE.x):
				var neighbors = count_neighboring_walls(Vector2i(x, y), grid)
				if grid[y][x]:
					new_grid[y][x] = neighbors > 3
				else:
					new_grid[y][x] = neighbors > 4
		
		# Swap references
		var temp = grid
		grid = new_grid
		new_grid = temp
		

	# Apply walls to terrain map
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if grid[y][x]:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL)


func add_nature() -> void:
	pass
func add_forage() -> void:
	pass
func add_decal() -> void:
	pass

func add_stairs() -> void:
	# Find candidate positions for stairs (walls with floor neighbors)
	var stair_candidates = []
	
	for y in range(1, GameData.MAP_SIZE.y - 1):
		for x in range(1, GameData.MAP_SIZE.x - 1):

			# skip around border
			if x < 8 or x > GameData.MAP_SIZE.x - 9 or y < 5 or y > GameData.MAP_SIZE.y - 6:
				continue


			if is_wall(Vector2i(x, y)) and has_floor_neighbor(Vector2i(x, y), 4):
				stair_candidates.append(Vector2i(x, y))
	
	# Place up stair
	var up_stair_pos
	if stair_candidates.size() > 0:
		up_stair_pos = stair_candidates[0]
		var up_spawn_pos = find_stair_spawn_position(up_stair_pos)
		place_stair(up_stair_pos, true, up_spawn_pos)
		stair_candidates.remove_at(0)
	
	# Place down stair (try to find one far from up stair)
	if stair_candidates.size() > 0:
		var down_stair_pos = find_farthest_stair_position(stair_candidates, up_stair_pos)
		var down_spawn_pos = find_stair_spawn_position(down_stair_pos)
		place_stair(down_stair_pos, false, down_spawn_pos)

# --- Utils ---


# func add_terrain_map_data(target_pos: Vector2i, tile_tag: int) -> void:

# 	var target_tile = terrain_map[target_pos.y][target_pos.x]
# 	var tile_data = GameData.get_tile_data(tile_tag)

# 	if target_tile["tags"].has(tile_tag):
# 		return
# 	target_tile["tags"].append(tile_tag)

# 	# apply most restrictive properties
# 	target_tile["walkable"] = target_tile["walkable"] and tile_data.walkable
# 	target_tile["transparent"] = target_tile["transparent"] and tile_data.transparent
