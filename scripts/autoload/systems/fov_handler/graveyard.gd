extends Node

const FOV_SOURCE_ID = 1
const UNEXPLORED_ATLAS = Vector2i(0, 0)
const EXPLORED_ATLAS = Vector2i(1, 0)


const CIRCLRE_FACTOR = 1.4142 # sqrt(2)

var fov_tilemap: TileMapLayer = null
var visible_tiles: Array[Vector2i] = []
var explored_tiles: Array[Vector2i] = []
var map_width: int = 0
var map_height: int = 0
var player_vision_range: int = 10

var debug := GameData.fov_manager_debug


func _ready() -> void:
	SignalBus.game_state_changed.connect(_process_toggle)
	SignalBus.player_acted.connect(update_fov)

	SignalBus.calculate_fov.connect(initialize_fov)

	# when world map pos changes save explored tiles
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


## Activates / deactivates fov based on game state
func _process_toggle(new_state: int) -> void:
	match new_state:
		GameState.GAME_STATES.PLAYING:
			activate_fov()
		_:
			deactivate_fov()


func _on_dungeon_entered(data: Dictionary) -> void:
	pass
	save_explored_tiles(Vector2i.ZERO, GameData.player.PlayerComp.world_map_pos)

func _on_dungeon_exited(data: Dictionary) -> void:
	pass

func _on_dungeon_level_changed(_new_level: int, _old_level: int) -> void:
	save_explored_tiles_dungeon(_old_level)

## sets fov tilemap
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

	# Get map dimensions
	map_height = GameData.terrain_map.size()
	if map_height > 0:
		map_width = GameData.terrain_map[0].size()
	
	# Initialize all tiles as unexplored
	for y in range(map_height):
		for x in range(map_width):
			fov_tilemap.set_cell(Vector2i(x, y), FOV_SOURCE_ID, UNEXPLORED_ATLAS)

	
	# load in exlored tiles
	if not GameData.current_dungeon:
		# if not in dungeon, load in from world map
		load_explored_tiles(GameData.player.PlayerComp.world_map_pos)
	else:
		# load in explored tiles from DungeonLevel
		load_explored_tiles_dungeon()

	
	# Calculate initial FOV
	update_fov()

func update_fov() -> void:
	if map_width == 0 || map_height == 0:
		return
	
	# Store previous visible tiles
	# var prev_visible = visible_tiles.duplicate()
	visible_tiles.clear()
	
	# Get player position
	var player_pos = ComponentRegistry.get_player_pos()
	
	# Mark player position as visible
	mark_visible(player_pos)
	
	var max_scan_depth = ceili(player_vision_range * CIRCLRE_FACTOR)
	# Calculate FOV using shadowcasting
	for quadrant_idx in range(4):
		var quadrant = Quadrant.new(quadrant_idx, player_pos, map_width, map_height)
		var first_row = Row.new(1, -1.0, 1.0)
		scan(first_row, quadrant, max_scan_depth)


	# Update tilemap based on visibility changes
	for y in range(map_height):
		for x in range(map_width):
			var pos = Vector2i(x, y)
			
			# Handle visible tiles
			if pos in visible_tiles:
				# Tile is visible - remove fog
				fov_tilemap.set_cell(pos, -1)
				# Mark as explored if not already
				if !pos in explored_tiles:
					explored_tiles.append(pos)
			
			# Handle previously explored tiles that are no longer visible
			elif pos in explored_tiles:
				# Tile is explored but not visible - show explored fog
				fov_tilemap.set_cell(pos, FOV_SOURCE_ID, EXPLORED_ATLAS)
			
			# Handle unexplored tiles
			else:
				# Tile is unexplored and not visible - show unexplored fog
				fov_tilemap.set_cell(pos, FOV_SOURCE_ID, UNEXPLORED_ATLAS)
	
	SignalBus.fov_calculated.emit()


# Shadowcasting implementation
func mark_visible(pos: Vector2i) -> void:
	if !is_position_valid(pos) || euclidean_distance(ComponentRegistry.get_player_pos(), pos) > player_vision_range:
		return
	if !pos in visible_tiles:
		visible_tiles.append(pos)

func scan(row: Row, quadrant: Quadrant, max_depth: int) -> void:
	if row.depth > max_depth:
		return
	
	var prev_tile: Vector2i = Vector2i(-1, -1)
	var tiles = row.tiles()
	var hit_opaque = false
	
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
				prev_transparent = get_tile_transparency(prev_world_tile)

		# Handle transitions between transparent and opaque tiles
		if !prev_transparent && current_transparent:
			# Wall to floor transition - narrow the field of view
			row.start_slope = slope(tile)
		elif prev_transparent && !current_transparent:
			# Floor to wall transition - create a new scan for the next row
			var next_row = row.next()
			next_row.end_slope = slope(tile)
			scan(next_row, quadrant, max_depth)
			hit_opaque = true

		# track if we hit an opaque tile
		if !current_transparent:
			hit_opaque = true

	
		prev_tile = tile
	
	# Continue scanning:
		# 1. if the last tile was transparent or
		# 2. We hit an opaque tile but haven't reached vision range
	if tiles.size() > 0 and (get_tile_transparency(quadrant.transform(tiles[-1])) || hit_opaque):
		var last_tile = tiles[tiles.size() - 1]
		var last_world_tile = quadrant.transform(last_tile)
		if is_position_valid(last_world_tile):
			if get_tile_transparency(last_world_tile):
				scan(row.next(), quadrant, max_depth)

# Helper functions
func is_position_valid(pos: Vector2i) -> bool:
	return pos.x >= 0 && pos.y >= 0 && pos.x < map_width && pos.y < map_height

func is_symmetric(row: Row, tile: Vector2i) -> bool:
	var col = tile.y
	var origin = Vector2i(0, 0)
	var tile_pos = Vector2i(row.depth, col)


	return euclidean_distance(origin, tile_pos) <= player_vision_range


func slope(tile: Vector2i) -> float:
	var row_depth = max(tile.x, 1)  # Prevent division by zero
	var col = tile.y
	return (2.0 * col - 1.0) / (2.0 * row_depth)


func euclidean_distance(a: Vector2i, b: Vector2i) -> float:
	var dx = absf(a.x - b.x)
	var dy = absf(a.y - b.y)
	return sqrt(dx * dx + dy * dy)

func chebyshev_distance(a: Vector2i, b: Vector2i) -> int:
	# return MapFunction.manhattan_distance(a, b)
	var dx = absi(a.x - b.x)
	var dy = absi(a.y - b.y)
	return maxi(dx, dy)

func get_tile_transparency(pos: Vector2i) -> bool:
	if !is_position_valid(pos):
		return false  # Treat out-of-bounds as opaque
	return MapFunction.is_tile_transparent(pos)


func save_explored_tiles(_new_pos: Vector2i, old_pos: Vector2i) -> void:
	if !explored_tiles:
		if debug:
			print("no tiles to save")
		return

	if debug:
		print("saving tiles for world map pos: ", old_pos)

	# duplicate the array, so it's not reference we are passing
	WorldMapData.world_map2.save_explored_tiles(old_pos, explored_tiles.duplicate())

	# set current explored and visible tiles to empty, since they have been saved
	explored_tiles.clear()
	visible_tiles.clear()


func load_explored_tiles(world_map_pos: Vector2i) -> void:

	explored_tiles = WorldMapData.world_map2.get_explored_tiles(world_map_pos)
	if debug:
		print("loading explored tiles for world map pos in FOV: ", world_map_pos)

func load_explored_tiles_dungeon() -> void:
	if debug:
		print("loading explored tiles for dungeon level: ", GameData.current_dungeon_level)
	explored_tiles = GameData.current_dungeon_class.get_explored_tiles(GameData.current_dungeon_level)
	


## Saves explored tiles to param `level` [br]
## using GameData.current_dungeon_class
func save_explored_tiles_dungeon(level: int) -> void:
	if debug:
		print("\tsaving explored tiles for dungeon level: ", level)
	GameData.current_dungeon_class.save_explored_tiles(level, explored_tiles.duplicate())

# Helper classes
class Quadrant:
	var cardinal: int
	var origin: Vector2i
	var map_width: int
	var map_height: int
	
	func _init(_cardinal: int, _origin: Vector2i, _map_width: int, _map_height: int):
		self.cardinal = _cardinal
		self.origin = _origin
		self.map_width = _map_width
		self.map_height = _map_height
	
	func transform(tile: Vector2i) -> Vector2i:
		var row = tile.x
		var col = tile.y	
		var result: Vector2i	
		match cardinal:

			0:  # North
				result = Vector2i(origin.x + col, origin.y - row)
			1:  # East
				result = Vector2i(origin.x + row, origin.y + col)
			2:  # South
				result = Vector2i(origin.x - col, origin.y + row)
			3:  # West
				result = Vector2i(origin.x - row, origin.y - col)
			_:
				result = origin
		result.x = clampi(result.x, 0, map_width - 1)
		result.y = clampi(result.y, 0, map_height - 1)
		return result

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
