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
		var new_grid = grid.duplicate(true)
		for y in range(GameData.MAP_SIZE.y):
			for x in range(GameData.MAP_SIZE.x):
				var neighbors = count_neighboring_walls(Vector2i(x, y), grid)
				if grid[y][x]:
					new_grid[y][x] = neighbors > 3
				else:
					new_grid[y][x] = neighbors > 4
		grid = new_grid

	# use cellural grid to set walls

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


# --- Utils ---


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
			if nx < 0 or nx >= GameData.MAP_SIZE.x or ny < 0 or ny >= GameData.MAP_SIZE.y:
				count += 1  # Count out-of-bounds as walls
			elif grid[ny][nx]:
				count += 1  # Count walls

	return count
