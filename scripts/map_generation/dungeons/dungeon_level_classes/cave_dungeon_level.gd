class_name CaveDungeonLevel
extends DungeonLevel

const NUM_OF_ITERATIONS = 4
const MIN_CAVE_SIZE = 50  # Minimum number of floor tiles for a valid cave
const CORRIDOR_WIDTH = 4


func generate_level_terrain() -> void:

	for y in range(GameData.MAP_SIZE.y):
		terrain_map.append([])
		for x in range(GameData.MAP_SIZE.x):
			terrain_map[y].append({
				"tags": [GameData.TILE_TAGS.FLOOR],
				"walkable": true,
				"transparent": true
			})

	add_walls()

	connect_cave_sections()

	add_nature()
	add_forage()
	add_decal()
	add_stairs()


# make the walls with cellural automata
func add_walls() -> void:
	# make cellural grid
	var grid = []
	for y in range(GameData.MAP_SIZE.y):
		grid.append([])
		for x in range(GameData.MAP_SIZE.x):
			var _is_wall = rng.randf() < 0.5

			# border walls
			if y == 0 or y == GameData.MAP_SIZE.y - 1 or x == 0 or x == GameData.MAP_SIZE.x - 1:
				_is_wall = true
			grid[y].append(_is_wall)

	
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
					new_grid[y][x] = neighbors >= 4
					# walls remain walls if enough neighbors
				else:
					new_grid[y][x] = neighbors >= 5
					# floor becomes wall if too many neighbors
		
		grid = new_grid
		

	# Apply walls to terrain map
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if grid[y][x]:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL)


func connect_cave_sections() -> void:
	var visited = []
	for y in range(GameData.MAP_SIZE.y):
		visited.append([])
		visited[y].resize(GameData.MAP_SIZE.x)
		visited[y].fill(false)

	var caves = []  # Array of cave sections, each is an array of Vector2i positions

	# Flood fill to find all cave sections
	for y in range(1, GameData.MAP_SIZE.y - 1):
		for x in range(1, GameData.MAP_SIZE.x - 1):
			if !visited[y][x] and !is_wall(Vector2i(x, y)):
				var cave = flood_fill_cave(Vector2i(x, y), visited)
				if cave.size() > 0:
					caves.append(cave)

	# If no caves or only one cave, nothing to connect
	if caves.size() <= 1:
		return

	# sort caves by size, largest first
	caves.sort_custom(func(a, b): return a.size() > b.size())

	var main_cave = caves[0] # largest cave


	for i in range(1, caves.size()):
		var small_cave = caves[i]

		# skip very small caves
		if small_cave.size() < MIN_CAVE_SIZE:
			# just fill them with walls
			for pos in small_cave:
				add_terrain_map_data(pos, GameData.TILE_TAGS.WALL)
			continue

		# Find closest points between main cave and this small cave
		var closest_pair = find_closest_cave_points(main_cave, small_cave)
		
		if closest_pair.size() == 2:
			# Dig a corridor between the caves
			dig_wide_corridor_smooth(closest_pair[0], closest_pair[1])
			
			# Add the small cave to the main cave so future connections can use it
			main_cave.append_array(small_cave)

# Flood fill algorithm to find connected cave sections
func flood_fill_cave(start: Vector2i, visited: Array) -> Array:
	var cave = []
	var queue = [start]
	visited[start.y][start.x] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		cave.append(current)
		
		# Check all 4 directions
		for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var neighbor = current + dir
			
			# Check bounds
			if neighbor.x < 1 || neighbor.x >= GameData.MAP_SIZE.x - 1 || \
			   neighbor.y < 1 || neighbor.y >= GameData.MAP_SIZE.y - 1:
				continue
			
			if !visited[neighbor.y][neighbor.x] && !is_wall(neighbor):
				visited[neighbor.y][neighbor.x] = true
				queue.append(neighbor)
	
	return cave


# Find the two closest points between two caves
func find_closest_cave_points(cave1: Array, cave2: Array) -> Array:
	var closest_distance = INF
	var closest_pair = []
	
	# Sample points to improve performance with large caves
	var sample1 = cave1
	var sample2 = cave2
	
	# For performance, sample larger caves
	if cave1.size() > 100:
		sample1 = []
		for i in range(0, cave1.size(), cave1.size() / 50):
			sample1.append(cave1[i])
	
	if cave2.size() > 100:
		sample2 = []
		for i in range(0, cave2.size(), cave2.size() / 50):
			sample2.append(cave2[i])
	
	# Find closest points between the two samples
	for pos1 in sample1:
		for pos2 in sample2:
			var distance = pos1.distance_squared_to(pos2)  # Use squared for performance
			if distance < closest_distance:
				closest_distance = distance
				closest_pair = [pos1, pos2]
	
	return closest_pair


# ALTERNATIVE: Even better wide corridor with smoothing
func dig_wide_corridor_smooth(start: Vector2i, end: Vector2i) -> void:
	var current = start
	var path = [start]
	
	# Find the path
	while current != end:
		var direction = end - current
		
		# Bias toward the target direction
		if rng.randf() < 0.7:  # 70% chance to move directly toward target
			if abs(direction.x) > abs(direction.y):
				current.x += sign(direction.x)
			else:
				current.y += sign(direction.y)
		else:  # 30% chance to wiggle
			if rng.randf() < 0.5:
				current.x += rng.randi_range(-1, 1)
			else:
				current.y += rng.randi_range(-1, 1)
		
		# Clamp to map bounds
		current.x = clamp(current.x, 1, GameData.MAP_SIZE.x - 2)
		current.y = clamp(current.y, 1, GameData.MAP_SIZE.y - 2)
		
		# Avoid adding duplicate positions
		if path[path.size() - 1] != current:
			path.append(current)
	
	# Widen and smooth the path
	for i in range(path.size()):
		var pos = path[i]
		
		# Determine corridor width - wider in the middle, narrower at ends
		var width = CORRIDOR_WIDTH
		if i < 3 or i > path.size() - 4:  # Taper ends
			width = max(1, CORRIDOR_WIDTH - 1)
		
		# Clear area around this path segment
		for y_offset in range(-width, width + 1):
			for x_offset in range(-width, width + 1):
				# Use circular pattern for more natural look
				if Vector2(x_offset, y_offset).length() > width + 0.5:
					continue
					
				var wide_pos = Vector2i(pos.x + x_offset, pos.y + y_offset)
				
				# Check bounds
				if wide_pos.x < 1 || wide_pos.x >= GameData.MAP_SIZE.x - 1 || \
				   wide_pos.y < 1 || wide_pos.y >= GameData.MAP_SIZE.y - 1:
					continue
				
				# Clear this position
				if is_wall(wide_pos):
					reset_terrain_map_data(wide_pos)
	
	# Apply a simple smoothing pass to the corridor
	smooth_corridor(path)

# Smooth the corridor edges for more natural look
func smooth_corridor(path: Array) -> void:
	for pos in path:
		for y_offset in range(-CORRIDOR_WIDTH-1, CORRIDOR_WIDTH+2):
			for x_offset in range(-CORRIDOR_WIDTH-1, CORRIDOR_WIDTH+2):
				var check_pos = Vector2i(pos.x + x_offset, pos.y + y_offset)
				
				# Check bounds
				if check_pos.x < 1 || check_pos.x >= GameData.MAP_SIZE.x - 1 || \
				   check_pos.y < 1 || check_pos.y >= GameData.MAP_SIZE.y - 1:
					continue
				
				# Skip if this is part of the main corridor
				if Vector2(x_offset, y_offset).length() <= CORRIDOR_WIDTH + 0.5:
					continue
				
				# Apply cellular automata rules to smooth edges
				if is_wall(check_pos):
					var wall_neighbors = 0
					for dy in range(-1, 2):
						for dx in range(-1, 2):
							if dx == 0 and dy == 0:
								continue
							var neighbor_pos = Vector2i(check_pos.x + dx, check_pos.y + dy)
							if neighbor_pos.x >= 0 && neighbor_pos.x < GameData.MAP_SIZE.x && \
							   neighbor_pos.y >= 0 && neighbor_pos.y < GameData.MAP_SIZE.y:
								if is_wall(neighbor_pos):
									wall_neighbors += 1
					
					# If wall has too few neighbors, remove it
					if wall_neighbors < 3:
						reset_terrain_map_data(check_pos)




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
