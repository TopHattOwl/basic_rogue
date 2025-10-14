class_name CampDungeonLevel
extends DungeonLevel

enum ROOM_SIZE { SMALL, MEDIUM, LARGE }

# Room size ranges
const SMALL_ROOM_MIN = Vector2i(4, 4)
const SMALL_ROOM_MAX = Vector2i(7, 7)
const MEDIUM_ROOM_MIN = Vector2i(8, 8)
const MEDIUM_ROOM_MAX = Vector2i(12, 12)
const LARGE_ROOM_MIN = Vector2i(13, 13)
const LARGE_ROOM_MAX = Vector2i(18, 18)

# Corridor dimensions
const WIDE_CORRIDOR_WIDTH = 3
const NARROW_CORRIDOR_WIDTH = 1

# Generation parameters
const MIN_ROOMS = 5
const MAX_ROOMS = 10
const ROOM_PADDING = 3  # Minimum space between rooms

# Room storage for enemy spawning
var rooms: Array[Dictionary] = []


func generate_level_terrain() -> void:
	# Initialize entire map as walls
	initialize_walls()
	
	# Generate rooms
	generate_rooms()
	
	# Connect large rooms with wide corridors
	connect_large_rooms()
	
	# Add connections to medium/small rooms from corridors
	connect_smaller_rooms()
	
	# Add stairs
	add_stairs()


func initialize_walls() -> void:
	for y in range(GameData.MAP_SIZE.y):
		terrain_map.append([])
		for x in range(GameData.MAP_SIZE.x):
			terrain_map[y].append({
				"tags": [GameData.TILE_TAGS.WALL],
				"walkable": false,
				"transparent": false
			})


func generate_rooms() -> void:
	var num_large = rng.randi_range(2, 3)
	var num_medium = rng.randi_range(2, 4)
	var num_small = rng.randi_range(2, 4)
	
	var attempts = 0
	var max_attempts = 200
	
	# Generate large rooms first (priority)
	for i in num_large:
		attempts = 0
		while attempts < max_attempts:
			var room = create_random_room(ROOM_SIZE.LARGE)
			if try_place_room(room):
				break
			attempts += 1
	
	# Generate medium rooms
	for i in num_medium:
		attempts = 0
		while attempts < max_attempts:
			var room = create_random_room(ROOM_SIZE.MEDIUM)
			if try_place_room(room):
				break
			attempts += 1
	
	# Generate small rooms
	for i in num_small:
		attempts = 0
		while attempts < max_attempts:
			var room = create_random_room(ROOM_SIZE.SMALL)
			if try_place_room(room):
				break
			attempts += 1


func create_random_room(size: ROOM_SIZE) -> Dictionary:
	var min_size: Vector2i
	var max_size: Vector2i
	
	match size:
		ROOM_SIZE.SMALL:
			min_size = SMALL_ROOM_MIN
			max_size = SMALL_ROOM_MAX
		ROOM_SIZE.MEDIUM:
			min_size = MEDIUM_ROOM_MIN
			max_size = MEDIUM_ROOM_MAX
		ROOM_SIZE.LARGE:
			min_size = LARGE_ROOM_MIN
			max_size = LARGE_ROOM_MAX
	
	var width = rng.randi_range(min_size.x, max_size.x)
	var height = rng.randi_range(min_size.y, max_size.y)
	
	var x = rng.randi_range(1, GameData.MAP_SIZE.x - width - 1)
	var y = rng.randi_range(1, GameData.MAP_SIZE.y - height - 1)
	
	return {
		"pos": Vector2i(x, y),
		"size": Vector2i(width, height),
		"center": Vector2i(x + width / 2, y + height / 2),
		"room_size": size
	}


func try_place_room(room: Dictionary) -> bool:
	# Check if room overlaps with existing rooms (including padding)
	for existing_room in rooms:
		if rooms_overlap(room, existing_room, ROOM_PADDING):
			return false
	
	# Check bounds
	if room.pos.x < 1 or room.pos.y < 1:
		return false
	if room.pos.x + room.size.x >= GameData.MAP_SIZE.x - 1:
		return false
	if room.pos.y + room.size.y >= GameData.MAP_SIZE.y - 1:
		return false
	
	# Place room
	carve_room(room)
	rooms.append(room)
	return true


func rooms_overlap(room1: Dictionary, room2: Dictionary, padding: int) -> bool:
	var r1_left = room1.pos.x - padding
	var r1_right = room1.pos.x + room1.size.x + padding
	var r1_top = room1.pos.y - padding
	var r1_bottom = room1.pos.y + room1.size.y + padding
	
	var r2_left = room2.pos.x - padding
	var r2_right = room2.pos.x + room2.size.x + padding
	var r2_top = room2.pos.y - padding
	var r2_bottom = room2.pos.y + room2.size.y + padding
	
	return not (r1_right < r2_left or r1_left > r2_right or r1_bottom < r2_top or r1_top > r2_bottom)


func carve_room(room: Dictionary) -> void:
	for y in range(room.pos.y, room.pos.y + room.size.y):
		for x in range(room.pos.x, room.pos.x + room.size.x):
			if x < 0 or x >= GameData.MAP_SIZE.x or y < 0 or y >= GameData.MAP_SIZE.y:
				continue
			reset_terrain_map_data(Vector2i(x, y))


func connect_large_rooms() -> void:
	var large_rooms = get_rooms_by_size(ROOM_SIZE.LARGE)
	
	if large_rooms.size() < 2:
		return
	
	# Connect each large room to the next one
	for i in range(large_rooms.size() - 1):
		carve_wide_corridor(large_rooms[i].center, large_rooms[i + 1].center)
	
	# Optionally connect last to first for a loop
	if large_rooms.size() > 2 and rng.randf() > 0.5:
		carve_wide_corridor(large_rooms[-1].center, large_rooms[0].center)


func carve_wide_corridor(from: Vector2i, to: Vector2i) -> void:
	var current = from
	
	# Horizontal first
	var x_dir = 1 if to.x > current.x else -1
	while current.x != to.x:
		carve_corridor_section(current, WIDE_CORRIDOR_WIDTH)
		current.x += x_dir
	
	# Then vertical
	var y_dir = 1 if to.y > current.y else -1
	while current.y != to.y:
		carve_corridor_section(current, WIDE_CORRIDOR_WIDTH)
		current.y += y_dir
	
	# Carve the final position
	carve_corridor_section(current, WIDE_CORRIDOR_WIDTH)


func carve_corridor_section(center: Vector2i, width: int) -> void:
	var offset = width / 2
	
	for dy in range(-offset, offset + 1):
		for dx in range(-offset, offset + 1):
			var pos = Vector2i(center.x + dx, center.y + dy)
			if pos.x >= 0 and pos.x < GameData.MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.MAP_SIZE.y:
				reset_terrain_map_data(pos)


func connect_smaller_rooms() -> void:
	var large_rooms = get_rooms_by_size(ROOM_SIZE.LARGE)
	var other_rooms = get_rooms_by_size(ROOM_SIZE.MEDIUM) + get_rooms_by_size(ROOM_SIZE.SMALL)
	
	if large_rooms.is_empty():
		# Fallback: connect all rooms to each other
		for i in range(rooms.size() - 1):
			carve_narrow_corridor(rooms[i].center, rooms[i + 1].center)
		return
	
	# Connect each small/medium room to nearest large room or corridor
	for room in other_rooms:
		var nearest_large = find_nearest_room(room, large_rooms)
		if nearest_large:
			carve_narrow_corridor(room.center, nearest_large.center)


func carve_narrow_corridor(from: Vector2i, to: Vector2i) -> void:
	var current = from
	
	# Choose random path style
	if rng.randf() > 0.5:
		# Horizontal first
		while current.x != to.x:
			reset_terrain_map_data(current)
			current.x += 1 if to.x > current.x else -1
		while current.y != to.y:
			reset_terrain_map_data(current)
			current.y += 1 if to.y > current.y else -1
	else:
		# Vertical first
		while current.y != to.y:
			reset_terrain_map_data(current)
			current.y += 1 if to.y > current.y else -1
		while current.x != to.x:
			reset_terrain_map_data(current)
			current.x += 1 if to.x > current.x else -1
	
	reset_terrain_map_data(current)


func get_rooms_by_size(size: ROOM_SIZE) -> Array:
	var result = []
	for room in rooms:
		if room.room_size == size:
			result.append(room)
	return result


func find_nearest_room(from_room: Dictionary, candidate_rooms: Array) -> Dictionary:
	if candidate_rooms.is_empty():
		return {}
	
	var nearest = candidate_rooms[0]
	var min_dist = from_room.center.distance_squared_to(nearest.center)
	
	for room in candidate_rooms:
		var dist = from_room.center.distance_squared_to(room.center)
		if dist < min_dist:
			min_dist = dist
			nearest = room
	
	return nearest


func add_stairs() -> void:
	if rooms.is_empty():
		push_error("No rooms generated for stairs placement")
		return
	
	# Place up stair in first large room, or first room if no large rooms
	var large_rooms = get_rooms_by_size(ROOM_SIZE.LARGE)
	var up_room = large_rooms[0] if not large_rooms.is_empty() else rooms[0]
	var up_pos = get_random_floor_in_room(up_room)
	var up_spawn = find_stair_spawn_position(up_pos)
	place_stair(up_pos, true, up_spawn)
	
	# Place down stair in last large room, or last room
	var down_room = large_rooms[-1] if not large_rooms.is_empty() else rooms[-1]
	var down_pos = get_random_floor_in_room(down_room)
	var down_spawn = find_stair_spawn_position(down_pos)
	place_stair(down_pos, false, down_spawn)


func get_random_floor_in_room(room: Dictionary) -> Vector2i:
	var x = rng.randi_range(room.pos.x + 1, room.pos.x + room.size.x - 2)
	var y = rng.randi_range(room.pos.y + 1, room.pos.y + room.size.y - 2)
	return Vector2i(x, y)


## Returns array of rooms for enemy spawning
func get_rooms() -> Array[Dictionary]:
	return rooms