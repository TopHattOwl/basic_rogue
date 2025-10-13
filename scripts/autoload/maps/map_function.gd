extends Node


var debug := GameData.map_functions_debug

func _ready() -> void:
	set_process(false)
	SignalBus.game_state_changed.connect(_process_toggle)

func _process_toggle(new_state: int) -> void:
	match new_state:
		GameState.GAME_STATES.PLAYING:
			set_process(true)
		_:
			set_process(false)

func _process(_delta: float) -> void:
	if GameData.player.PlayerComp.is_in_world_map:
		set_world_map_mouse_pos()
	else:
		set_zoomed_in_mouse_pos()

# --- MOUSE GRID POS ---

var zoomed_in_mouse_pos: Vector2i
var world_map_mouse_pos: Vector2i
		
func set_world_map_mouse_pos():
	var player_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos

	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	var mouse_screen_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = camera.get_screen_transform().affine_inverse() * mouse_screen_pos
	var mouse_grid_pos = MapFunction.to_grid_pos(mouse_world_pos) + player_pos + Vector2i(1,1)

	world_map_mouse_pos = mouse_grid_pos.clamp(Vector2i(0,0), GameData.WORLD_MAP_SIZE - Vector2i(1,1))

func set_zoomed_in_mouse_pos():
	var player_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos

	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return

	var mouse_screen_pos = get_viewport().get_mouse_position()
	var mouse_world_pos = camera.get_screen_transform().affine_inverse() * mouse_screen_pos
	var mouse_grid_pos = MapFunction.to_grid_pos(mouse_world_pos) + player_pos + Vector2i(1,1)

	zoomed_in_mouse_pos = mouse_grid_pos.clamp(Vector2i(0,0), GameData.MAP_SIZE - Vector2i(1,1))


# --- Misc ---
func to_world_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * GameData.TILE_SIZE.x + GameData.OFFSET.x, pos.y * GameData.TILE_SIZE.y + GameData.OFFSET.y)

func to_grid_pos(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor((pos.x - GameData.OFFSET.x) / GameData.TILE_SIZE.x),
		floor((pos.y - GameData.OFFSET.y) / GameData.TILE_SIZE.y)
	)

# --- CHECKS ---
func is_tile_walkable(pos: Vector2i) -> bool:
	if !is_in_bounds(pos):
		return false
	return GameData.terrain_map[pos.y][pos.x]["walkable"]

func is_tile_transparent(pos: Vector2i) -> bool:
	if !is_in_bounds(pos):
		return false
	return GameData.terrain_map[pos.y][pos.x]["transparent"]

func is_in_bounds(pos: Vector2i) -> bool:

	# cehck for dungeon if in dungeon
	# if GameData.player.PlayerComp.is_in_dungeon:
	# 	return pos.x >= 0 and pos.x < currentDungeonSize.x and pos.y >= 0 and pos.y < currentDUngeonSize.y
	return pos.x >= 0 and pos.x < GameData.MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.MAP_SIZE.y


func can_spawn_monster_at_pos(pos: Vector2i) -> bool:

	if !is_tile_walkable(pos):
		return false
	if !is_in_bounds(pos):
		return false
	if GameData.actors_map[pos.y][pos.x] != null:
		return false
	return true

# --- GETTERS ---

## Returns PackedVector2Array of line between two grid positions [br]
## Includes start and end positions, if start pos is not needed use PackedVector2Array.remove_at(0)
func get_line(from: Vector2i, to: Vector2i) -> PackedVector2Array:

	var line = PackedVector2Array()
	var _to = Vector2(to)
	var _from = Vector2(from)
	var current = Vector2(from)
	
	line.append(current)
	
	if current == _to:
		return line
	
	var dx = _to.x - _from.x
	var dy = _to.y - _from.y
	var abs_dx = absi(dx)
	var abs_dy = absi(dy)
	var steps = maxi(abs_dx, abs_dy)  # Chebyshev distance determines steps
	var step_x = sign(dx) if dx != 0 else 0
	var step_y = sign(dy) if dy != 0 else 0
	
	# Handle single-step moves (adjacent tiles)
	if steps == 1:
		line.append(_to)
		return line
	
	# Digital Differential Analyzer (DDA) with Chebyshev adaptation
	var x_accumulator: float = 0.0
	var y_accumulator: float = 0.0
	var x_increment = abs_dx / float(steps)
	var y_increment = abs_dy / float(steps)
	
	for _step in range(steps):
		x_accumulator += x_increment
		y_accumulator += y_increment
		var x_move = floori(x_accumulator + 0.5)  # Round to nearest integer
		var y_move = floori(y_accumulator + 0.5)
		x_accumulator -= x_move
		y_accumulator -= y_move
		
		current += Vector2(x_move * step_x, y_move * step_y)
		if current != line[line.size() - 1]:
			line.append(current)
	
	return line


func get_tile_info(grid_pos: Vector2i) -> Dictionary:
	if !GameData.terrain_map:
		return {}
	if not is_in_bounds(grid_pos):
		return {}

	return GameData.terrain_map[grid_pos.y][grid_pos.x]

func chebyshev_distance(a: Vector2i, b: Vector2i) -> int:
	return max(abs(a.x - b.x), abs(a.y - b.y)) 

func manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)

func euclidean_distance(a: Vector2i, b: Vector2i) -> float:
	return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))


func get_tiles_in_radius(
	origin: Vector2i,
	radius: int,
	check_for_vision = false, # if true, does not include tiles that are not visible
	include_origin: bool = true, # if true, includes origin
	calc_method: String = "chebyshev", # calculation method for radius
	check_walkable: bool = false, # if true, does not include tiles that are not walkable
	check_actors: bool = false, # if true, does not include tiles that are occupied by actors
	) -> Array:
	var tiles: Array[Vector2i] = []

	# Validate inputs
	if radius < 0:
		push_error("radius must be non-negative, given radius: " + str(radius))
		return tiles
	
	if calc_method not in ["chebyshev", "manhattan", "euclidean"]:
		push_error("Invalid calc_method: " + calc_method + ", defaulting to 'chebyshev'")
		calc_method = "chebyshev"

	var map_height = GameData.terrain_map.size()
	var map_width = GameData.terrain_map[0].size() if map_height > 0 else 0

	if map_height <= 0 or map_width <= 0:
		push_error("Map dimensions are non positive: " + str(map_width) +"x"+ str(map_height))
		return tiles


	# check vision if needed
	var visible_tiles_set: Dictionary
	if check_for_vision:
		visible_tiles_set = {}
		for tile in FovManager.visible_tiles:
			visible_tiles_set[tile] = true


	# get base bounding box, later, if calc_method is not chebyshev, parts of it will be discarded
	var min_x = maxi(0, origin.x - radius)
	var max_x = mini(origin.x + radius, map_width - 1)
	var min_y = maxi(0, origin.y - radius)
	var max_y = mini(origin.y + radius, map_height - 1)

	# max_y + 1 bc range() is not inclusive for last value
	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var tile = Vector2i(x, y)
			var distance: float

			# skip origin if not needed
			if !include_origin and tile == origin:
				continue

			# walkable check
			if check_walkable and not is_tile_walkable(tile):
				continue

			# actors check
			if check_actors and get_actor(tile):
				continue
			
			match calc_method:
				"chebyshev":
					distance = float(chebyshev_distance(origin, tile))
				"manhattan":
					distance = float(manhattan_distance(origin, tile))
				"euclidean":
					distance = euclidean_distance(origin, tile)
			
			if distance <= float(radius):
				# apply vision check if needed
				if check_for_vision:
					if tile in visible_tiles_set:
						tiles.append(tile)
				else:
					tiles.append(tile)

	return tiles


func check_actors_in_radius(
	origin: Vector2i,
	radius: int,
	check_for_vision = false, # if true, does not include tiles that are not visible
	include_origin: bool = true, # if true, includes origin
	calc_method: String = "chebyshev", # calculation method for radius
	check_walkable: bool = false, # if true, does not include tiles that are not walkable
) -> Array:
	var tiles: Array[Vector2i] = []
	# Validate inputs
	if radius < 0:
		push_error("radius must be non-negative, given radius: " + str(radius))
		return tiles
	
	if calc_method not in ["chebyshev", "manhattan", "euclidean"]:
		push_error("Invalid calc_method: " + calc_method + ", defaulting to 'chebyshev'")
		calc_method = "chebyshev"

	var map_height = GameData.terrain_map.size()
	var map_width = GameData.terrain_map[0].size() if map_height > 0 else 0

	if map_height <= 0 or map_width <= 0:
		push_error("Map dimensions are non positive: " + str(map_width) +"x"+ str(map_height))
		return tiles


	# check vision if needed
	var visible_tiles_set: Dictionary
	if check_for_vision:
		visible_tiles_set = {}
		for tile in FovManager.visible_tiles:
			visible_tiles_set[tile] = true

	# get base bounding box, later, if calc_method is not chebyshev, parts of it will be discarded
	var min_x = maxi(0, origin.x - radius)
	var max_x = mini(origin.x + radius, map_width - 1)
	var min_y = maxi(0, origin.y - radius)
	var max_y = mini(origin.y + radius, map_height - 1)

	# max_y + 1 bc range() is not inclusive for last value
	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var tile = Vector2i(x, y)
			var distance: float

			# if not actor skip, we are looking for actors
			if not get_actor(tile):
				continue

			# skip origin if not needed
			if !include_origin and tile == origin:
				continue

			# walkable check
			if check_walkable and not is_tile_walkable(tile):
				continue

			
			
			match calc_method:
				"chebyshev":
					distance = float(chebyshev_distance(origin, tile))
				"manhattan":
					distance = float(manhattan_distance(origin, tile))
				"euclidean":
					distance = euclidean_distance(origin, tile)
			
			if distance <= float(radius):
				# apply vision check if needed
				if check_for_vision:
					if tile in visible_tiles_set:
						tiles.append(tile)
				else:
					tiles.append(tile)

	return tiles


func get_actor(grid_pos: Vector2i) -> Node2D:
	if !GameData.actors_map:
		return null
	if not is_in_bounds(grid_pos):
		return null
	return GameData.actors_map[grid_pos.y][grid_pos.x]

func get_items(grid_pos: Vector2i) -> Array:
	if !GameData.items_map:
		return []
	if not is_in_bounds(grid_pos):
		return []
	return GameData.items_map[grid_pos.y][grid_pos.x]

# --- MAP DATA ---

## Initializes all map data (filles it with floor, null etc.)
## also initializes fov data, fov autoload will handle reading the loaded in terrain_map
func initialize_map_data():
	if debug:
		print("init map data")
	# reset variables
	GameData.reset_maps()
	for y in range(GameData.MAP_SIZE.y):

		GameData.terrain_map.append([])
		GameData.actors_map.append([])
		GameData.items_map.append([])
		for x in range(GameData.MAP_SIZE.x):
			var floor_data = GameData.get_tile_data(GameData.TILE_TAGS.FLOOR)
			var tile_data = {
				"tags": [GameData.TILE_TAGS.FLOOR],
				"walkable": floor_data.walkable,
				"transparent": floor_data.transparent,
			}
			GameData.terrain_map[y].append(tile_data)
			GameData.actors_map[y].append(null)
			GameData.items_map[y].append([])


## parse tile layers from preloaded scenes, generated maps first generate this data and draw later
func parse_tile_layers_from_scene(map_root: Node2D) -> void:
	# TODO: use GameData.TilemapLayers dictionary to get all layers

	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)
			
			# add terrain data from tile layers
			for key in GameData.TilemapLayers.keys():

				# floor is always there (when terrain_map is initialized floor is added as base)
				if key == GameData.TILE_TAGS.FLOOR or key == GameData.TILE_TAGS.NONE:
					continue
				var layer = map_root.get_node_or_null(GameData.TilemapLayers[key])
				if layer and layer.get_cell_tile_data(grid_pos):
					var tile_info = GameData.get_tile_data(key)
					add_terrain_map_data(grid_pos, key, tile_info)

	
	# initialize astar afther collecting terrain_data
	initialize_astar_grid()
				

func add_terrain_map_data(target_pos: Vector2i, tag: int, tile_info: Dictionary) -> void:
	
	var target_tile = GameData.terrain_map[target_pos.y][target_pos.x]

	target_tile["tags"].append(tag)

	# apply most restrictive properties
	target_tile["walkable"] = target_tile["walkable"] and tile_info.walkable
	target_tile["transparent"] = target_tile["transparent"] and tile_info.transparent


## ads player to all_actors and actors_map
func add_player_to_variables(player: Node2D) -> void:
	var grid_pos = ComponentRegistry.get_component(player, GameData.ComponentKeys.POSITION).grid_pos
	GameData.actors_map[grid_pos.y][grid_pos.x] = player

func add_hostile_to_variables(actor: Node2D) -> void:
	GameData.all_hostile_actors.append(actor)
	var grid_pos = ComponentRegistry.get_component(actor, GameData.ComponentKeys.POSITION).grid_pos
	GameData.actors_map[grid_pos.y][grid_pos.x] = actor

func add_friendly_to_variables(actor: Node2D) -> void:
	GameData.all_friendly_actors.append(actor)
	var grid_pos = ComponentRegistry.get_component(actor, GameData.ComponentKeys.POSITION).grid_pos
	GameData.actors_map[grid_pos.y][grid_pos.x] = actor

# --- TileSets ---
func get_tile_texture(tilemap_layer: TileMapLayer, grid_pos: Vector2i) -> Texture2D:

	# get tile data
	var source_id = tilemap_layer.get_cell_source_id(grid_pos)
	if source_id == -1:
		return null
	var atlas_coords = tilemap_layer.get_cell_atlas_coords(grid_pos)

	# get tileset resource
	var tileset = tilemap_layer.tile_set
	var source = tileset.get_source(source_id) as TileSetAtlasSource

	# get texture and region
	var texture = source.texture
	var region = source.get_tile_texture_region(atlas_coords)

	# creade sub-region texture
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = region
	return atlas_texture

## returns an array of tile layers at grid_pos
func get_tile_map_layers(grid_pos: Vector2i) -> Dictionary:

	var tilemap_layers = {}
	for key in GameData.TilemapLayers.keys():
		var layer = GameData.current_map.get_node_or_null(GameData.TilemapLayers[key])
		if layer and layer.get_cell_tile_data(grid_pos):
			tilemap_layers[key] = layer

	return tilemap_layers

# --- AStar ---

var astar_grid: AStarGrid2D

func initialize_astar_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0, 0, GameData.MAP_SIZE.x, GameData.MAP_SIZE.y) # changed astar_grid.size to region (size is Deprecated)
	astar_grid.cell_size = Vector2i(1, 1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar_grid.update()
	
	# Set walkable cells based on terrain
	for y in GameData.MAP_SIZE.y:
		for x in GameData.MAP_SIZE.x:
			var pos = Vector2i(x, y)
			astar_grid.set_point_solid(pos, !GameData.terrain_map[y][x].walkable)

	astar_add_actors(GameData.all_hostile_actors)

## Adds actors to astar for pathfinding
## Should be called only when all actors have spawned down 
func astar_add_actors(actors: Array) -> void:
	for actor in actors:
		var grid_pos = ComponentRegistry.get_component(actor, GameData.ComponentKeys.POSITION).grid_pos
		astar_grid.set_point_solid(grid_pos, true)


## Toggles walkable cells based on actors 
func astar_toggle_walkable(grid_pos: Vector2i) -> void:
	if not astar_grid.is_in_bounds:
		push_error("Grid pos is out of bounds")
		return

	if astar_grid.is_point_solid(grid_pos):
		astar_grid.set_point_solid(grid_pos, false)
		return
	else:
		astar_grid.set_point_solid(grid_pos, true)


## Returns path from a grid position to another [br]
## returned PackedVector2Array contains the from grid pos as well[br]
## returned PackedVector2Array is empty if path is not found [br]
func astar_get_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:

	return astar_grid.get_id_path(from, to, true)

# --- Map loading ---

## loads a premade map into GameData.current_map
func load_premade_map(map_path: String) -> void:

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null


	GameData.remove_entities()

	GameData.current_map = load(map_path).instantiate()
	GameData.main_node.add_child(GameData.current_map)

	parse_tile_layers_from_scene(GameData.current_map)


	# after tile layers are parsed emit fov update
	SignalBus.calculate_fov.emit()
	SignalBus.entered_premade_map.emit({
		"world_pos": GameData.player.PlayerComp.world_map_pos
	})

# --- Transition ---
#	when zoomed in and trying to move outside of world map
func transition_map(new_world_map_pos: Vector2i, new_player_grid_pos):

	if !WorldMapData.world_map2:
		push_error("Error: No world map data, world_map is null")

	# check world map borders and walkable
	if not WorldMapData.world_map2.is_in_bounds(new_world_map_pos) or not WorldMapData.world_map2.is_tile_walkable(new_world_map_pos):
		return

	# No need to remove entities, they will be removed if:
		# map is premade and premade map is loaded
		# or when biome map generates or loads a map

	var world_tile = WorldMapData.world_map2.map_data[new_world_map_pos.y][new_world_map_pos.x]

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos = new_world_map_pos
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos = new_player_grid_pos
	GameData.player.position = MapFunction.to_world_pos(new_player_grid_pos)

	# if map is premade, load the map
	if world_tile.is_premade:
		load_premade_map(world_tile.map_path)

	# if not premade chekc if explored (if explored then it has been generated already)
	else:
		# biome map generates map is not generated, but load map if already generated
		WorldMapData.biome_map.generate_map(new_world_map_pos)



# --- World Map ---
	
func enter_world_map():
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map = true

	# opening the world map
	var world_map = load(DirectoryPaths.world_map_scene).instantiate()
	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	GameData.remove_entities()

	GameData.player.position = MapFunction.to_world_pos(ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos)
	GameData.main_node.add_child(world_map)

	# message log
	UiFunc.log_message("You enter the world map")

	# set camera data (zoom, limits)
	UiFunc.update_camera_data()
	UiFunc.toggle_sidebar()

	# set player input mode
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode = GameData.INPUT_MODES.WORLD_MAP_MOVEMENT

	# TODO: save the data about current map and load world map and put player at the right position
	
func exit_world_map():
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map = false

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	

	GameData.player.PositionComp.grid_pos = GameData.WORLD_SPAWN_POS
	var player_world_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos
	GameData.player.position = MapFunction.to_world_pos(GameData.player.PositionComp.grid_pos)

	var current_map_data = WorldMapData.world_map2.map_data[player_world_pos.y][player_world_pos.x]

	if current_map_data.is_premade:
		load_premade_map(current_map_data.map_path)
	else:
		# TODO is explored load that data ininstead, not generate
		WorldMapData.biome_map.generate_map(player_world_pos)


	UiFunc.log_message("You exit the world map")

	# set camera data (zoom, limits)
	UiFunc.update_camera_data()
	UiFunc.toggle_sidebar()

	# queue free world map
	if GameData.main_node.has_node("WorldMap"):
		GameData.main_node.get_node("WorldMap").queue_free()

	# set player input mode
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode = GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT

func is_in_world_map(pos:Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GameData.WORLD_MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.WORLD_MAP_SIZE.y



# --- CONSTRUCTORS ---

## Makes base terrain map filled with floor
func make_base_terrain_map() -> Array:
	var terrain_map = []
	for y in GameData.MAP_SIZE.y:
		terrain_map.append([])
		for x in GameData.MAP_SIZE.x:
			terrain_map[y].append({
				"tags": [GameData.TILE_TAGS.FLOOR],
				"walkable": true,
				"transparent": true
			})
	return terrain_map
