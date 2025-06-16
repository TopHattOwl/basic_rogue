extends Node

enum TILE_STATE { UNEXPLORED, EXPLORED, VISIBLE }

## the id of the terrain set
@export var terrain_set: int = 0

## the id of the unexplored terrain inside the terrain set
@export var unexplored_terrain: int = 0

## the id of the explored terrain inside the terrain set
@export var explored_terrain: int = 1 

var player_vision_range: int = 10
var explored_tiles: PackedByteArray  = PackedByteArray()
var visible_tiles: PackedByteArray  = PackedByteArray()

var fov_tilemap: TileMapLayer


var map_size: Vector2i
var map_width: int
var map_height: int


# shadow casting constants
const MULTIPLIERS = [
	[1, 0, 0, -1, -1, 0, 0, 1],
	[0, 1, -1, 0, 0, -1, 1, 0],
	[0, 1, 1, 0, 0, -1, -1, 0],
	[1, 0, 0, 1, -1, 0, 0, -1]
]


func _ready() -> void:
	SignalBus.game_state_changed.connect(_process_toggle)
	SignalBus.player_acted.connect(_update_fov)


	SignalBus.calculate_fov.connect(initialize_fov)


func _process(_delta: float) -> void:
	if GameData.player.PlayerComp.is_in_world_map:
		fov_tilemap.visible = false
	else:
		fov_tilemap.visible = true

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
	fov_tilemap = GameData.main_node.get_node("FOV").get_node("TileMapLayer")



func deactivate_fov() -> void:
	if GameData.fov_manager_debug:
		print("deactivating fov")
	fov_tilemap = null



func initialize_fov() -> void:

	if GameData.fov_manager_debug:
		print(" --- initializing fov ---")

	map_size = Vector2i(GameData.terrain_map[0].size(), GameData.terrain_map.size())
	map_width = map_size.x
	map_height = map_size.y

	explored_tiles = PackedByteArray()
	explored_tiles.resize(map_width * map_height)
	explored_tiles.fill(0)

	visible_tiles = PackedByteArray()
	visible_tiles.resize(map_width * map_height)
	visible_tiles.fill(0)


	if GameData.player.PlayerComp.is_in_world_map:
		if GameData.fov_manager_debug:
			print("dont need to update fov, player is in world map")
		return
	_update_fov()


func _update_fov() -> void:
	if GameData.fov_manager_debug:
		print(" --- updating fov ---")

	var player_pos = ComponentRegistry.get_player_pos()

	# reset current visibility
	visible_tiles.fill(0)

	# player pos is always visible
	_set_tile_visible(player_pos, true)

	# Calculate FOV using recursive shadow casting
	for octant in 8:
		_cast_light(player_pos, 1, 1.0, 0.0, octant)

	_update_exploration()
	_update_fog_of_war()


func _cast_light(origin: Vector2i, row: int, start_slope: float, end_slope: float, octant: int) -> void:
	if start_slope < end_slope:
		return
	
	var next_start_slope = start_slope
	var x = origin.x
	var y = origin.y
	
	for j in range(row, player_vision_range + 1):
		var blocked = false
		var dx = -j
		var dy = -j
		
		while dx <= 0:
			# Calculate local coordinates
			var lx = x + dx * MULTIPLIERS[0][octant] + dy * MULTIPLIERS[1][octant]
			var ly = y + dx * MULTIPLIERS[2][octant] + dy * MULTIPLIERS[3][octant]
			
			# Calculate slopes
			var l_slope = (dx - 0.5) / (dy + 0.5) if dy != -0.5 else 1.0
			var r_slope = (dx + 0.5) / (dy - 0.5) if dy != 0.5 else 1.0
			
			if next_start_slope < r_slope:
				dx += 1
				continue
			elif end_slope > l_slope:
				break
			
			# Check bounds
			if lx >= 0 and lx < map_width and ly >= 0 and ly < map_height:
				# Check if within circular radius
				if dx * dx + dy * dy <= player_vision_range * player_vision_range:
					_set_tile_visible(Vector2i(lx, ly), true)
				
				# Handle blocking tiles
				if blocked:
					if !MapFunction.is_tile_transparent(Vector2i(lx, ly)):
						next_start_slope = r_slope
						dx += 1
						continue
					else:
						blocked = false
						start_slope = next_start_slope
				else:
					if !MapFunction.is_tile_transparent(Vector2i(lx, ly)):
						blocked = true
						next_start_slope = r_slope
						_cast_light(origin, j + 1, start_slope, l_slope, octant)
			
			dx += 1
		
		if blocked:
			break

func _update_exploration():
	for i in range(visible_tiles.size()):
		if visible_tiles[i] > 0:
			explored_tiles[i] = 1

		
func _update_fog_of_war():
	if !fov_tilemap:
		return
	
	# Batch update for performance
	fov_tilemap.clear()
	
	var unexplored_cells = []
	var explored_cells = []
	
	for y in range(map_height):
		for x in range(map_width):
			var idx = y * map_width + x
			var pos = Vector2i(x, y)
			
			if visible_tiles[idx] > 0:
				# Visible - no fog
				continue
			elif explored_tiles[idx] > 0:
				explored_cells.append(pos)
			else:
				unexplored_cells.append(pos)
	
	# Set tiles in batches
	if unexplored_cells.size() > 0:
		fov_tilemap.set_cells_terrain_connect(
			unexplored_cells, terrain_set, unexplored_terrain, true
		)

	
	if explored_cells.size() > 0:
		fov_tilemap.set_cells_terrain_connect(
			explored_cells, terrain_set, explored_terrain, true
		)


# --- HELPERS ---
func _set_tile_visible(pos: Vector2i, visible: bool) -> void:
	var index = pos.y * map_width + pos.x
	visible_tiles[index] = 1 if visible else 0

func _get_tile_visible(pos: Vector2i) -> bool:
	var index = pos.y * map_width + pos.x
	return visible_tiles[index] > 0


# --- PUBLIC ---
func is_visible(pos: Vector2i) -> bool:
	if pos.x < 0 || pos.x >= map_width || pos.y < 0 || pos.y >= map_height:
		return false
	return _get_tile_visible(Vector2i(pos.x, pos.y))

func is_explored(pos: Vector2i) -> bool:
	if pos.x < 0 || pos.x >= map_width || pos.y < 0 || pos.y >= map_height:
		return false
	var idx = pos.y * map_width + pos.x
	return explored_tiles[idx] > 0 if idx >= 0 and idx < explored_tiles.size() else false

func get_visible_tiles() -> Array:
	var visible = []
	for y in range(map_height):
		for x in range(map_width):
			if _get_tile_visible(Vector2i(x, y)):
				visible.append(Vector2i(x, y))
	return visible

func get_explored_tiles() -> Array:
	var explored = []
	for y in range(map_height):
		for x in range(map_width):
			if is_explored(Vector2i(x, y)):
				explored.append(Vector2i(x, y))
	return explored


func save_fov_state() -> Dictionary:
	return {
		"explored": explored_tiles,
		"map_width": map_width,
		"map_height": map_height
	}

func load_fov_state(data: Dictionary):
	explored_tiles = data["explored"]
	map_width = data["map_width"]
	map_height = data["map_height"]
	
	# Reinitialize arrays
	visible_tiles = PackedByteArray()
	visible_tiles.resize(map_width * map_height)
	visible_tiles.fill(0)
