extends Node


# --- Misc ---
func to_world_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * GameData.TILE_SIZE.x + GameData.OFFSET.x, pos.y * GameData.TILE_SIZE.y + GameData.OFFSET.y)


func to_grid_pos(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor((pos.x - GameData.OFFSET.x) / GameData.TILE_SIZE.x),
		floor((pos.y - GameData.OFFSET.y) / GameData.TILE_SIZE.y)
	)


func is_tile_walkable(pos: Vector2i) -> bool:
	return GameData.terrain_map[pos.y][pos.x]["walkable"]


func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GameData.MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.MAP_SIZE.y


func get_tile_info(grid_pos: Vector2i) -> Dictionary:
	if not is_in_bounds(grid_pos):
		return {}

	return GameData.terrain_map[grid_pos.y][grid_pos.x]

func chebyshev_distance(a: Vector2i, b: Vector2i) -> int:
	return max(abs(a.x - b.x), abs(a.y - b.y)) 


# --- Map data ---
func initialize_map_data():
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


func parse_tile_layers_from_scene(map_root: Node2D) -> void:

	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			var grid_pos = Vector2i(x, y)
			var wall_layer = map_root.get_node_or_null("WallLayer")
			var door_layer = map_root.get_node_or_null("DoorLayer")
			var stair_layer = map_root.get_node_or_null("StairLayer")

			# checks if in grid_pos there is a tile in the given layer
			if wall_layer and wall_layer.get_cell_tile_data(grid_pos):
				var tile_info = GameData.get_tile_data(GameData.TILE_TAGS.WALL)
				add_terrain_map_data(grid_pos, GameData.TILE_TAGS.WALL, tile_info)
				

			if door_layer and door_layer.get_cell_tile_data(grid_pos):
				var tile_info = GameData.get_tile_data(GameData.TILE_TAGS.DOOR)
				add_terrain_map_data(grid_pos, GameData.TILE_TAGS.DOOR, tile_info)
				
				
			if stair_layer and stair_layer.get_cell_tile_data(grid_pos):
				var tile_info = GameData.get_tile_data(GameData.TILE_TAGS.STAIR)
				add_terrain_map_data(grid_pos,GameData.TILE_TAGS.STAIR ,tile_info)
	
	# initialize astar afther collecting terrain_data
	MapFunction.initialize_astar_grid()
				

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

func add_item_to_variables(item: Node2D) -> void:
	var grid_pos = ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_POSITION).grid_pos
	GameData.items_map[grid_pos.y][grid_pos.x].append(item)
	GameData.all_items.append(item)

func remove_item_from_variables(item: Node2D) -> void:
	var grid_pos = ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_POSITION).grid_pos
	GameData.items_map[grid_pos.y][grid_pos.x].erase(item)
	GameData.all_items.erase(item)

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

func astar_get_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	if astar_grid.is_in_boundsv(from) and astar_grid.is_in_boundsv(to):
		return astar_grid.get_id_path(from, to)
	return PackedVector2Array()

# --- Map loading ---

## loads a premade map into GameData.current_map
func load_premade_map(map_path: String) -> void:

	# reset variables
	initialize_map_data()
	GameData.reset_entity_variables()

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	
	GameData.current_map = load(map_path).instantiate()
	GameData.main_node.add_child(GameData.current_map)

	parse_tile_layers_from_scene(GameData.current_map)

	# spawn player if not spawned already
	if GameData.player:
		return
	EntitySystems.entity_spawner.spawn_player()



# --- Transition ---
#	when zoomed in and trying to move outside of world map
func transition_map(new_world_map_pos: Vector2i, new_player_grid_pos):

	if !WorldMapData.world_map:
		push_error("Error: No world map data, world_map is null")
	# check world map borders
	if not is_in_world_map(new_world_map_pos):
		return

	# TODO save current map data

	# save player data
	SaveFuncs.save_player_data(GameData.player)

	var world_tile = WorldMapData.world_map[new_world_map_pos.y][new_world_map_pos.x]
	var is_transition_success = false
	if world_tile.is_premade:
		load_premade_map(world_tile.map_path)
		print("map is premade")
		is_transition_success = true
	else:
		Generators.generate_random_map(new_world_map_pos)
		
	if is_transition_success:

		# update variables and player pos
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos = new_world_map_pos
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos = new_player_grid_pos
		GameData.player.position = MapFunction.to_world_pos(new_player_grid_pos)
	else:
		print("transition failed")

# --- World Map ---
	
func enter_world_map():
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map = true

	# opening the world map
	var world_map = load(DirectoryPaths.world_map_scene).instantiate()
	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null

	GameData.player.position = MapFunction.to_world_pos(ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos)
	GameData.main_node.add_child(world_map)

	# message log
	UiFunc.log_message("You enter the world map")

	# set camera limits
	GameData.player.get_node("Camera2D").limit_right = GameData.WORLD_MAP_SIZE.x * GameData.TILE_SIZE.x
	GameData.player.get_node("Camera2D").limit_bottom = GameData.WORLD_MAP_SIZE.y * GameData.TILE_SIZE.y

	# set camera zoom
	var camera = GameData.player.get_node("Camera2D")
	camera.zoom = Vector2(0.4, 0.4)
	# TODO: save the data about current map and load world map and put player at the right position
	
func exit_world_map():
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map = false

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	
	var player_pos_comp = ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION)
	var player_world_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos
	GameData.player.position = MapFunction.to_world_pos(player_pos_comp.grid_pos)

	var current_map_data = WorldMapData.world_map[player_world_pos.y][player_world_pos.x]

	if current_map_data.is_premade:
		load_premade_map(current_map_data.map_path)
	else:
		Generators.generate_random_map(player_world_pos)


	UiFunc.log_message("You exit the world map")

	GameData.player.get_node("Camera2D").limit_right = GameData.MAP_SIZE.x * GameData.TILE_SIZE.x
	GameData.player.get_node("Camera2D").limit_bottom = GameData.MAP_SIZE.y * GameData.TILE_SIZE.y

	# set camera zoom
	var camera = GameData.player.get_node("Camera2D")
	camera.zoom = Vector2(0.8, 0.8)

	# queue free world map
	if GameData.main_node.has_node("WorldMap"):
		GameData.main_node.get_node("WorldMap").queue_free()

func is_in_world_map(pos:Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GameData.WORLD_MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.WORLD_MAP_SIZE.y
