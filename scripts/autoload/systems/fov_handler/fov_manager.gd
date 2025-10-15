extends Node

const FOV_SOURCE_ID = 1
const UNEXPLORED_ATLAS = Vector2i(0, 0)
const EXPLORED_ATLAS = Vector2i(1, 0)

var fov_tilemap: TileMapLayer = null
var visible_tiles: Dictionary = {}  # Use Dictionary for O(1) lookup
var explored_tiles: Dictionary = {}  # Use Dictionary for O(1) lookup
var prev_visible_tiles: Dictionary = {}  # Track what was visible last frame
var map_width: int = 0
var map_height: int = 0
var player_vision_range: int = 10

var debug := GameData.fov_manager_debug


func _ready() -> void:
	SignalBus.game_state_changed.connect(_process_toggle)
	SignalBus.player_acted.connect(update_fov)
	SignalBus.calculate_fov.connect(initialize_fov)
	SignalBus.world_map_pos_changed.connect(save_explored_tiles)
	SignalBus.entered_dungeon.connect(_on_dungeon_entered)
	SignalBus.exited_dungeon.connect(_on_dungeon_exited)
	SignalBus.dungeon_level_changed.connect(_on_dungeon_level_changed)


func _process(_delta: float) -> void:
	if not GameData.player:
		return
	if GameData.player.PlayerComp.is_in_world_map:
		if fov_tilemap:
			fov_tilemap.visible = false
	elif fov_tilemap:
		fov_tilemap.visible = true


func _process_toggle(new_state: int) -> void:
	match new_state:
		GameState.GAME_STATES.PLAYING:
			activate_fov()
		_:
			deactivate_fov()


func _on_dungeon_entered(_data: Dictionary) -> void:
	save_explored_tiles(Vector2i.ZERO, GameData.player.PlayerComp.world_map_pos)


func _on_dungeon_exited(_data: Dictionary) -> void:
	pass


func _on_dungeon_level_changed(_new_level: int, _old_level: int) -> void:
	save_explored_tiles_dungeon(_old_level)


func activate_fov() -> void:
	if debug:
		print("activating fov")
	fov_tilemap = GameData.main_node.get_node("FOV").get_node("TileMapLayer")


func deactivate_fov() -> void:
	if debug:
		print("deactivating fov")
	fov_tilemap = null


func initialize_fov() -> void:
	if debug:
		print("Initializing fov manager")

	map_width = 0
	map_height = 0
	visible_tiles.clear()
	explored_tiles.clear()
	prev_visible_tiles.clear()

	# Get map dimensions
	map_height = GameData.terrain_map.size()
	if map_height > 0:
		map_width = GameData.terrain_map[0].size()
	
	# Initialize all tiles as unexplored
	for y in range(map_height):
		for x in range(map_width):
			fov_tilemap.set_cell(Vector2i(x, y), FOV_SOURCE_ID, UNEXPLORED_ATLAS)

	# Load explored tiles
	if not GameData.current_dungeon:
		load_explored_tiles(GameData.player.PlayerComp.world_map_pos)
	else:
		load_explored_tiles_dungeon()
	
	# Calculate initial FOV
	update_fov()


func update_fov() -> void:
	if map_width == 0 or map_height == 0:
		return
	
	# Store previous visible tiles
	prev_visible_tiles = visible_tiles.duplicate()
	visible_tiles.clear()
	
	# Get player position
	var player_pos = ComponentRegistry.get_player_pos()
	
	# Mark player position as visible
	visible_tiles[player_pos] = true
	
	# Cast rays in 360 degrees for accurate shadowcasting
	cast_fov_rays(player_pos)
	
	# Update only changed tiles
	update_tilemap_efficiently()
	
	SignalBus.fov_calculated.emit()


func cast_fov_rays(origin: Vector2i) -> void:
	# Cast rays for each octant using recursive shadowcasting
	for octant in 8:
		cast_octant(origin, octant, 1, 0.0, 1.0)


func cast_octant(origin: Vector2i, octant: int, row: int, start_slope: float, end_slope: float) -> void:
	if start_slope >= end_slope:
		return
	
	if row > player_vision_range:
		return
	
	var prev_blocked := false
	var new_start := start_slope
	
	for col in range(row + 1):
		# Calculate slopes for this tile
		var left_slope := (float(col) - 0.5) / float(row + 0.5)
		var right_slope := (float(col) + 0.5) / float(row - 0.5)
		
		# Skip if outside current sector
		if left_slope > end_slope or right_slope < start_slope:
			continue
		
		# Transform to world coordinates
		var tile_pos := transform_octant(origin, row, col, octant)
		
		# Check if tile is in bounds
		if not is_in_bounds(tile_pos):
			continue
		
		# Check if tile is in vision range (circular)
		var distance := origin.distance_to(tile_pos)
		if distance > player_vision_range:
			continue
		
		# Mark tile as visible
		visible_tiles[tile_pos] = true
		
		# Check if tile blocks vision
		var blocks := is_tile_opaque(tile_pos)
		
		if prev_blocked:
			if blocks:
				# Still blocked, update start slope
				new_start = right_slope
			else:
				# Transition from blocked to open
				prev_blocked = false
				start_slope = new_start
		else:
			if blocks:
				# Transition from open to blocked - recurse with narrowed sector
				cast_octant(origin, octant, row + 1, start_slope, left_slope)
				prev_blocked = true
				new_start = right_slope
	
	# Continue to next row if not blocked
	if not prev_blocked:
		cast_octant(origin, octant, row + 1, start_slope, end_slope)


func transform_octant(origin: Vector2i, row: int, col: int, octant: int) -> Vector2i:
	match octant:
		0: return Vector2i(origin.x + col, origin.y - row)  # N
		1: return Vector2i(origin.x + row, origin.y - col)  # NE
		2: return Vector2i(origin.x + row, origin.y + col)  # E
		3: return Vector2i(origin.x + col, origin.y + row)  # SE
		4: return Vector2i(origin.x - col, origin.y + row)  # S
		5: return Vector2i(origin.x - row, origin.y + col)  # SW
		6: return Vector2i(origin.x - row, origin.y - col)  # W
		7: return Vector2i(origin.x - col, origin.y - row)  # NW
	return origin


func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < map_width and pos.y < map_height


func is_tile_opaque(pos: Vector2i) -> bool:
	if not is_in_bounds(pos):
		return true
	return not GameData.terrain_map[pos.y][pos.x]["transparent"]


func update_tilemap_efficiently() -> void:
	# Only update tiles that changed state
	var tiles_to_update: Dictionary = {}
	
	# Check newly visible tiles
	for tile in visible_tiles:
		if not tile in prev_visible_tiles:
			tiles_to_update[tile] = "visible"
		# Mark as explored
		explored_tiles[tile] = true
	
	# Check tiles that became hidden
	for tile in prev_visible_tiles:
		if not tile in visible_tiles:
			tiles_to_update[tile] = "explored"
	
	# Update only changed tiles
	for tile in tiles_to_update:
		var state = tiles_to_update[tile]
		match state:
			"visible":
				# Remove fog for visible tiles
				fov_tilemap.set_cell(tile, -1)
			"explored":
				# Show explored fog for previously visible tiles
				fov_tilemap.set_cell(tile, FOV_SOURCE_ID, EXPLORED_ATLAS)


func save_explored_tiles(_new_pos: Vector2i, old_pos: Vector2i) -> void:
	if explored_tiles.is_empty():
		if debug:
			print("no tiles to save")
		return

	if debug:
		print("saving tiles for world map pos: ", old_pos)

	# Convert dictionary keys to array
	var explored_array: Array[Vector2i] = []
	for tile in explored_tiles:
		explored_array.append(tile)
	
	WorldMapData.world_map2.save_explored_tiles(old_pos, explored_array)
	
	# Clear current state
	explored_tiles.clear()
	visible_tiles.clear()
	prev_visible_tiles.clear()


func load_explored_tiles(world_map_pos: Vector2i) -> void:
	var tiles_array = WorldMapData.world_map2.get_explored_tiles(world_map_pos)
	
	# Convert array to dictionary for fast lookup
	explored_tiles.clear()
	for tile in tiles_array:
		explored_tiles[tile] = true
		# Set explored fog on tilemap
		fov_tilemap.set_cell(tile, FOV_SOURCE_ID, EXPLORED_ATLAS)
	
	if debug:
		print("loading explored tiles for world map pos in FOV: ", world_map_pos)


func load_explored_tiles_dungeon() -> void:
	if debug:
		print("loading explored tiles for dungeon level: ", GameData.current_dungeon_level)
	
	var tiles_array = GameData.current_dungeon_class.get_explored_tiles(GameData.current_dungeon_level)
	
	# Convert array to dictionary
	explored_tiles.clear()
	for tile in tiles_array:
		explored_tiles[tile] = true
		# Set explored fog on tilemap
		fov_tilemap.set_cell(tile, FOV_SOURCE_ID, EXPLORED_ATLAS)


func save_explored_tiles_dungeon(level: int) -> void:
	if debug:
		print("\tsaving explored tiles for dungeon level: ", level)
	
	# Convert dictionary to array
	var explored_array: Array[Vector2i] = []
	for tile in explored_tiles:
		explored_array.append(tile)
	
	GameData.current_dungeon_class.save_explored_tiles(level, explored_array)
