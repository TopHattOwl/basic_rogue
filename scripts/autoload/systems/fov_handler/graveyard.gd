extends Node

# enum TILE_STATE { UNEXPLORED, EXPLORED, VISIBLE }

## the id of the terrain set
@export var terrain_set: int = 0

## the id of the unexplored terrain inside the terrain set
@export var unexplored_terrain: int = 0

## the id of the explored terrain inside the terrain set
@export var explored_terrain: int = 1 

# var player_vision_range: int = 10
# var explored_tiles: PackedByteArray  = PackedByteArray()
# var visible_tiles: PackedByteArray  = PackedByteArray()

# var fov_tilemap: TileMapLayer


# var map_size: Vector2i
# var map_width: int
# var map_height: int


# # shadow casting constants
# const MULTIPLIERS = [
# 	[1, 0, 0, -1, -1, 0, 0, 1],
# 	[0, 1, -1, 0, 0, -1, 1, 0],
# 	[0, 1, 1, 0, 0, -1, -1, 0],
# 	[1, 0, 0, 1, -1, 0, 0, -1]
# ]


# func _ready() -> void:
# 	SignalBus.game_state_changed.connect(_process_toggle)
# 	SignalBus.player_acted.connect(_update_fov)


# 	SignalBus.calculate_fov.connect(initialize_fov)


# func _process(_delta: float) -> void:
# 	if GameData.player.PlayerComp.is_in_world_map:
# 		fov_tilemap.visible = false
# 	else:
# 		fov_tilemap.visible = true

# func _process_toggle(new_state: int) -> void:
# 	match new_state:
# 		GameState.GAME_STATES.PLAYING:
# 			activate_fov()
# 		_:
# 			deactivate_fov()

# ## sets fov tilemap
# func activate_fov() -> void:
# 	if GameData.fov_manager_debug:
# 		print("activating fov")
# 	fov_tilemap = GameData.main_node.get_node("FOV").get_node("TileMapLayer")



# func deactivate_fov() -> void:
# 	if GameData.fov_manager_debug:
# 		print("deactivating fov")
# 	fov_tilemap = null



# func initialize_fov() -> void:

# 	if GameData.fov_manager_debug:
# 		print(" --- initializing fov ---")

# 	map_size = Vector2i(GameData.terrain_map[0].size(), GameData.terrain_map.size())
# 	map_width = map_size.x
# 	map_height = map_size.y

# 	explored_tiles = PackedByteArray()
# 	explored_tiles.resize(map_width * map_height)
# 	explored_tiles.fill(0)

# 	visible_tiles = PackedByteArray()
# 	visible_tiles.resize(map_width * map_height)
# 	visible_tiles.fill(0)


# 	if GameData.player.PlayerComp.is_in_world_map:
# 		if GameData.fov_manager_debug:
# 			print("dont need to update fov, player is in world map")
# 		return
# 	_update_fov()


# func _update_fov() -> void:
# 	if GameData.fov_manager_debug:
# 		print(" --- updating fov ---")

# 	var player_pos = ComponentRegistry.get_player_pos()

# 	# reset current visibility
# 	visible_tiles.fill(0)

# 	# player pos is always visible
# 	_set_tile_visible(player_pos, true)

# 	# Calculate FOV using recursive shadow casting
# 	for octant in 8:
# 		_cast_light(player_pos, 1, 1.0, 0.0, octant)

# 	_update_exploration()
# 	_update_fog_of_war()


# func _cast_light(origin: Vector2i, row: int, start_slope: float, end_slope: float, octant: int) -> void:
# 	if start_slope < end_slope:
# 		return
	
# 	var next_start_slope = start_slope
# 	var x = origin.x
# 	var y = origin.y
	
# 	for j in range(row, player_vision_range + 1):
# 		var blocked = false
# 		var dx = -j
# 		var dy = -j
		
# 		while dx <= 0:
# 			# Calculate local coordinates
# 			var lx = x + dx * MULTIPLIERS[0][octant] + dy * MULTIPLIERS[1][octant]
# 			var ly = y + dx * MULTIPLIERS[2][octant] + dy * MULTIPLIERS[3][octant]
			
# 			# Calculate slopes
# 			var l_slope = (dx - 0.5) / (dy + 0.5) if dy != -0.5 else 1.0
# 			var r_slope = (dx + 0.5) / (dy - 0.5) if dy != 0.5 else 1.0
			
# 			if next_start_slope < r_slope:
# 				dx += 1
# 				continue
# 			elif end_slope > l_slope:
# 				break
			
# 			# Check bounds
# 			if lx >= 0 and lx < map_width and ly >= 0 and ly < map_height:
# 				# Check if within circular radius
# 				if dx * dx + dy * dy <= player_vision_range * player_vision_range:
# 					_set_tile_visible(Vector2i(lx, ly), true)
				
# 				# Handle blocking tiles
# 				if blocked:
# 					if !MapFunction.is_tile_transparent(Vector2i(lx, ly)):
# 						next_start_slope = r_slope
# 						dx += 1
# 						continue
# 					else:
# 						blocked = false
# 						start_slope = next_start_slope
# 				else:
# 					if !MapFunction.is_tile_transparent(Vector2i(lx, ly)):
# 						blocked = true
# 						next_start_slope = r_slope
# 						_cast_light(origin, j + 1, start_slope, l_slope, octant)
			
# 			dx += 1
		
# 		if blocked:
# 			break

# func _update_exploration():
# 	for i in range(visible_tiles.size()):
# 		if visible_tiles[i] > 0:
# 			explored_tiles[i] = 1

		
# func _update_fog_of_war():
# 	if !fov_tilemap:
# 		return
	
# 	# Batch update for performance
# 	fov_tilemap.clear()
	
# 	var unexplored_cells = []
# 	var explored_cells = []
	
# 	for y in range(map_height):
# 		for x in range(map_width):
# 			var idx = y * map_width + x
# 			var pos = Vector2i(x, y)
			
# 			if visible_tiles[idx] > 0:
# 				# Visible - no fog
# 				continue
# 			elif explored_tiles[idx] > 0:
# 				explored_cells.append(pos)
# 			else:
# 				unexplored_cells.append(pos)
	
# 	# Set tiles in batches
# 	if unexplored_cells.size() > 0:
# 		fov_tilemap.set_cells_terrain_connect(
# 			unexplored_cells, terrain_set, unexplored_terrain, true
# 		)

	
# 	if explored_cells.size() > 0:
# 		fov_tilemap.set_cells_terrain_connect(
# 			explored_cells, terrain_set, explored_terrain, true
# 		)


# # --- HELPERS ---
# func _set_tile_visible(pos: Vector2i, visible: bool) -> void:
# 	var index = pos.y * map_width + pos.x
# 	visible_tiles[index] = 1 if visible else 0

# func _get_tile_visible(pos: Vector2i) -> bool:
# 	var index = pos.y * map_width + pos.x
# 	return visible_tiles[index] > 0


# # --- PUBLIC ---
# func is_visible(pos: Vector2i) -> bool:
# 	if pos.x < 0 || pos.x >= map_width || pos.y < 0 || pos.y >= map_height:
# 		return false
# 	return _get_tile_visible(Vector2i(pos.x, pos.y))

# func is_explored(pos: Vector2i) -> bool:
# 	if pos.x < 0 || pos.x >= map_width || pos.y < 0 || pos.y >= map_height:
# 		return false
# 	var idx = pos.y * map_width + pos.x
# 	return explored_tiles[idx] > 0 if idx >= 0 and idx < explored_tiles.size() else false

# func get_visible_tiles() -> Array:
# 	var visible = []
# 	for y in range(map_height):
# 		for x in range(map_width):
# 			if _get_tile_visible(Vector2i(x, y)):
# 				visible.append(Vector2i(x, y))
# 	return visible

# func get_explored_tiles() -> Array:
# 	var explored = []
# 	for y in range(map_height):
# 		for x in range(map_width):
# 			if is_explored(Vector2i(x, y)):
# 				explored.append(Vector2i(x, y))
# 	return explored


# func save_fov_state() -> Dictionary:
# 	return {
# 		"explored": explored_tiles,
# 		"map_width": map_width,
# 		"map_height": map_height
# 	}

# func load_fov_state(data: Dictionary):
# 	explored_tiles = data["explored"]
# 	map_width = data["map_width"]
# 	map_height = data["map_height"]
	
# 	# Reinitialize arrays
# 	visible_tiles = PackedByteArray()
# 	visible_tiles.resize(map_width * map_height)
# 	visible_tiles.fill(0)



# # ____________ NEW _________________

# # fov tilemap's tileset data
# const FOV_SOURCE_ID = 1
# const UNEXPLORED_ATLAS = Vector2i(0, 0)
# const EXPLORED_ATLAS = Vector2i(1, 0)

# var fov_tilemap: TileMapLayer = null

# # not sure how to store visible and explored tiles, explored tiles would be needed to save for the map (so that once explored it would be always explored)
# var visible_tiles: Dictionary = {}
# var explored_tiles: Dictionary = {}

# var map_width: int
# var map_height: int

# var player_vision_range: int = 12

# var player_gird_pos: Vector2i


# func _ready() -> void:
# 	SignalBus.game_state_changed.connect(_process_toggle)
# 	SignalBus.player_acted.connect(_update_fov)


# 	# calculate_fov gets emitted when a map is loaded and terrain_map is filled fo fov can be calculated
# 	SignalBus.calculate_fov.connect(initialize_fov)



# func _process(_delta: float) -> void:
# 	if GameData.player.PlayerComp.is_in_world_map:
# 		if fov_tilemap:
# 			fov_tilemap.visible = false
# 	elif fov_tilemap:
# 		fov_tilemap.visible = true

# ## Activates / deactivates fov based on game state
# func _process_toggle(new_state: int) -> void:
# 	match new_state:
# 		GameState.GAME_STATES.PLAYING:
# 			activate_fov()
# 		_:
# 			deactivate_fov()

# ## sets fov tilemap
# func activate_fov() -> void:
# 	if GameData.fov_manager_debug:
# 		print("activating fov")
# 	fov_tilemap = GameData.main_node.get_node("FOV").get_node("TileMapLayer")
# func deactivate_fov() -> void:
# 	if GameData.fov_manager_debug:
# 		print("deactivating fov")
# 	fov_tilemap = null


# ## Initializes fov
# func initialize_fov() -> void:
# 	if GameData.fov_manager_debug:
# 		print("Initializing fov manager")

	
# 	# get map dimensions
# 	map_height = GameData.terrain_map.size()
# 	map_width = GameData.terrain_map[0].size()

# 	# clear prev data
# 	visible_tiles.clear()
# 	explored_tiles.clear()

# 	# init all tiles as unexplored
# 	for y in range(map_height):
# 		for x in range(map_width):
# 			var pos = Vector2i(x, y)
# 			visible_tiles[pos] = false
# 			explored_tiles[pos] = false

# 			fov_tilemap.set_cell(pos, FOV_SOURCE_ID, UNEXPLORED_ATLAS)

# 	player_gird_pos = ComponentRegistry.get_player_pos()

# 	_update_fov()

# func _update_fov():
# 	if !fov_tilemap or map_width == 0 or map_height == 0:
# 		return

# 	var prev_visible = visible_tiles.duplicate()
# 	visible_tiles.clear()



# ------ NEWNEWNEWNEW ------

const FOV_SOURCE_ID = 1
const UNEXPLORED_ATLAS = Vector2i(0, 0)
const EXPLORED_ATLAS = Vector2i(1, 0)

var fov_tilemap: TileMapLayer = null
var visible_tiles: Array[Vector2i] = []
var explored_tiles: Array[Vector2i] = []
var map_width: int = 0
var map_height: int = 0
var player_vision_range: int = 8
var is_active: bool = false

func _ready() -> void:
	SignalBus.game_state_changed.connect(_process_toggle)
	SignalBus.player_acted.connect(update_fov)

	SignalBus.calculate_fov.connect(initialize_fov)


func _process(_delta: float) -> void:
	if GameData.player.PlayerComp.is_in_world_map:
		if fov_tilemap:
			fov_tilemap.visible = false
			is_active = false
	elif fov_tilemap:
		fov_tilemap.visible = true
		is_active = true

## Activates / deactivates fov based on game state
func _process_toggle(new_state: int) -> void:
	match new_state:
		GameState.GAME_STATES.PLAYING:
			activate_fov()
		_:
			deactivate_fov()

## sets fov tilemap
func activate_fov() -> void:
	if GameData.fov_manager_debug:
		print("activating fov")
	is_active = true
	fov_tilemap = GameData.main_node.get_node("FOV").get_node("TileMapLayer")
func deactivate_fov() -> void:
	if GameData.fov_manager_debug:
		print("deactivating fov")

	is_active = false
	fov_tilemap = null


func initialize_fov() -> void:
	if GameData.fov_manager_debug:
			print("Initializing fov manager")

	map_width = 0
	map_height = 0
	visible_tiles.clear()
	explored_tiles.clear()

	# Get map dimensions
	map_height = GameData.terrain_map.size()
	if map_height > 0:
		map_width = GameData.terrain_map[0].size()
	
	# Initialize all tiles as unexplored
	for y in range(map_height):
		for x in range(map_width):
			fov_tilemap.set_cell(Vector2i(x, y), FOV_SOURCE_ID, UNEXPLORED_ATLAS)
	
	# Calculate initial FOV
	update_fov()

func update_fov() -> void:
	if map_width == 0 || map_height == 0:
		return
	
	# Store previous visible tiles
	var prev_visible = visible_tiles.duplicate()
	visible_tiles.clear()
	
	# Get player position
	var player_pos = ComponentRegistry.get_player_pos()
	
	# Mark player position as visible
	mark_visible(player_pos)
	
	# Calculate FOV using shadowcasting
	for quadrant_idx in range(4):
		var quadrant = Quadrant.new(quadrant_idx, player_pos)
		var first_row = Row.new(1, -1.0, 1.0)
		scan(first_row, quadrant)
	
	# Update tilemap based on visibility changes
	for pos in prev_visible:
		if !pos in visible_tiles:
			# Tile is no longer visible but was explored
			if pos in explored_tiles:
				fov_tilemap.set_cell(pos, FOV_SOURCE_ID, EXPLORED_ATLAS)
	
	for pos in visible_tiles:
		# Tile is visible - remove fog
		fov_tilemap.set_cell(pos, -1)
		# Mark as explored
		if !pos in explored_tiles:
			explored_tiles.append(pos)

# Shadowcasting implementation
func mark_visible(pos: Vector2i) -> void:
	if !is_position_valid(pos) || chebyshev_distance(ComponentRegistry.get_player_pos(), pos) > player_vision_range:
		return
	if !pos in visible_tiles:
		visible_tiles.append(pos)

func scan(row: Row, quadrant: Quadrant) -> void:
	if row.depth > player_vision_range:
		return
	
	var prev_tile: Vector2i = Vector2i(-1, -1)
	var tiles = row.tiles()
	
	for tile in tiles:
		var world_tile = quadrant.transform(tile)
		
		if !is_position_valid(world_tile):
			continue

		if is_symmetric(row, tile):
			mark_visible(world_tile)
		
		var current_transparent = MapFunction.is_tile_transparent(world_tile)
		var prev_transparent = true
		if prev_tile != Vector2i(-1, -1):
			var prev_world_tile = quadrant.transform(prev_tile)
			if is_position_valid(prev_world_tile):
				prev_transparent = MapFunction.is_tile_transparent(prev_world_tile)

		# Handle transitions between transparent and opaque tiles
		if !prev_transparent && current_transparent:
			# Wall to floor transition - narrow the field of view
			row.start_slope = slope(tile)
		elif prev_transparent && !current_transparent:
			# Floor to wall transition - create a new scan for the next row
			var next_row = row.next()
			next_row.end_slope = slope(tile)
			scan(next_row, quadrant)

		prev_tile = tile
	
	# Continue scanning if the last tile was transparent
	if tiles.size() > 0:
		var last_tile = tiles[tiles.size() - 1]
		var last_world_tile = quadrant.transform(last_tile)
		if is_position_valid(last_world_tile):
			if MapFunction.is_tile_transparent(last_world_tile):
				scan(row.next(), quadrant)

# Helper functions
func is_position_valid(pos: Vector2i) -> bool:
	return pos.x >= 0 && pos.y >= 0 && pos.x < map_width && pos.y < map_height

func is_symmetric(row: Row, tile: Vector2i) -> bool:
	var col = tile.y
	return col >= row.depth * row.start_slope && col <= row.depth * row.end_slope

func slope(tile: Vector2i) -> float:
	var row_depth = max(tile.x, 1)  # Prevent division by zero
	var col = tile.y
	return (2.0 * col - 1.0) / (2.0 * row_depth)

func chebyshev_distance(a: Vector2i, b: Vector2i) -> int:
	var dx = absi(a.x - b.x)
	var dy = absi(a.y - b.y)
	return maxi(dx, dy)

# Helper classes
class Quadrant:
	var cardinal: int
	var origin: Vector2i
	
	func _init(_cardinal: int, _origin: Vector2i):
		self.cardinal = _cardinal
		self.origin = _origin
	
	func transform(tile: Vector2i) -> Vector2i:
		var row = tile.x
		var col = tile.y
		
		match cardinal:
			0:  # North
				return Vector2i(origin.x + col, origin.y - row)
			1:  # East
				return Vector2i(origin.x + row, origin.y + col)
			2:  # South
				return Vector2i(origin.x + col, origin.y + row)
			3:  # West
				return Vector2i(origin.x - row, origin.y + col)
			_:
				return origin

class Row:
	var depth: int
	var start_slope: float
	var end_slope: float
	
	func _init(_depth: int, _start_slope: float, _end_slope: float):
		self.depth = _depth
		self.start_slope = _start_slope
		self.end_slope = _end_slope
	
	func tiles() -> Array[Vector2i]:
		var min_col = ceili(depth * start_slope)
		var max_col = floori(depth * end_slope)
		var _tiles: Array[Vector2i] = []

		# Ensure we have at least one tile to process
		if min_col > max_col:
			return _tiles
		
		for col in range(min_col, max_col + 1):
			_tiles.append(Vector2i(depth, col))
		
		return _tiles
	
	func next() -> Row:
		return Row.new(depth + 1, start_slope, end_slope)
