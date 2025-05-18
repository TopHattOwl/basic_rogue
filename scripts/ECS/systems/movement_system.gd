class_name MovementSystem
extends Node

# this main_node variable is set in main_node.gd's ready function by entity_systems.gd
var main_node: Node2D

## attemps to move entity to new_pos, returns true if successful
func process_movement(entity: Node, new_pos: Vector2i) -> bool:

	var position_component = ComponentRegistry.get_component(entity, GameData.ComponentKeys.POSITION)

	# Error check
	if not position_component:
		push_error("No position component found for entity: ", entity.name)
		return false

	# player component check
	var is_current_actor_player = GameData.player == entity

	# Map transition check
	# if player is zoomed in and trying to move outside of world map
	var dir = new_pos - position_component.grid_pos
	if is_current_actor_player and check__map_transition(new_pos, dir):
		# if map transition is successful it's still player's move (free move)
		return false

	
	# Combat check
	var faction = ComponentRegistry.get_component(entity, GameData.ComponentKeys.IDENTITY).faction
	var actor_at_pos = GameData.actors_map[new_pos.y][new_pos.x]

	if actor_at_pos:
		if faction != ComponentRegistry.get_component(actor_at_pos, GameData.ComponentKeys.IDENTITY).faction:
			return EntitySystems.combat_system.melee_attack(entity, actor_at_pos)


	# general movement check
	if MapFunction.is_tile_walkable(new_pos) and MapFunction.is_in_bounds(new_pos):
		
		var old_pos = position_component.grid_pos
		# update component
		position_component.grid_pos = new_pos

		# update variables
		GameData.actors_map[old_pos.y][old_pos.x] = null
		GameData.actors_map[new_pos.y][new_pos.x] = entity

		# update astar if not player (if player's pos in astar if solid, monsters will not 'see' them)
		if not is_current_actor_player:
			MapFunction.astar_toggle_walkable(old_pos)
			MapFunction.astar_toggle_walkable(new_pos)

		# visual update
		entity.position = MapFunction.to_world_pos(new_pos)

		return true

	# Dungeon enter check
	if MapFunction.get_tile_info(new_pos)["tags"].has(GameData.TILE_TAGS.STAIR) and is_current_actor_player:
		print("enter dungeon")

	return false


func process_world_map_movement(new_pos: Vector2i) -> bool:
	var position_component = ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION)
	var world_map_gird_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER)

	if not position_component:
		push_error("No position component found for player")
		return false
	if not world_map_gird_pos:
		return false
	if not WorldMapData.world_map[new_pos.y][new_pos.x].walkable:
		return false

	if MapFunction.is_in_world_map(new_pos):
		world_map_gird_pos.world_map_pos = new_pos
		GameData.player.position = MapFunction.to_world_pos(new_pos)
		return true

	return false


func check__map_transition(new_pos: Vector2i, dir: Vector2i) -> bool:

	# if player is zoomed in and trying to move outside of world map (not in bounds)
	if not MapFunction.is_in_bounds(new_pos):
		var player_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
		var transition_dir: Vector2i
		var new_player_grid_pos: Vector2i
		if new_pos.x >= GameData.MAP_SIZE.x and new_pos.y >= GameData.MAP_SIZE.y:
			transition_dir = Vector2i(1, 1)
			new_player_grid_pos = Vector2i(0, 0)
			
		elif new_pos.x < 0 and new_pos.y >= GameData.MAP_SIZE.y:
			transition_dir = Vector2i(-1, 1)
			new_player_grid_pos = Vector2i(GameData.MAP_SIZE.x - 1 ,0)
			
		elif new_pos.x >= GameData.MAP_SIZE.x and new_pos.y < 0:
			transition_dir = Vector2i(1, -1)
			new_player_grid_pos = Vector2i(0, GameData.MAP_SIZE.y - 1)
			
		elif new_pos.x < 0 and new_pos.y < 0:
			transition_dir = Vector2i(-1, -1)
			new_player_grid_pos = Vector2i(GameData.MAP_SIZE.x - 1, GameData.MAP_SIZE.y - 1)
			
		elif new_pos.x < 0:
			transition_dir = Vector2i(-1, 0)
			new_player_grid_pos = Vector2i(GameData.MAP_SIZE.x - 1, player_pos.y + dir.y)
			
		elif new_pos.x >= GameData.MAP_SIZE.x:
			transition_dir = Vector2i(1, 0)
			new_player_grid_pos = Vector2i(0, player_pos.y + dir.y)
			
		elif new_pos.y < 0:
			transition_dir = Vector2i(0, -1)
			new_player_grid_pos = Vector2i(player_pos.x + dir.x, GameData.MAP_SIZE.y - 1)
			
		elif new_pos.y >= GameData.MAP_SIZE.y:
			transition_dir = Vector2i(0, 1)
			new_player_grid_pos = Vector2i(player_pos.x + dir.x, 0)

		var new_world_pos = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos + transition_dir
		
		# change map
		MapFunction.transition_map(new_world_pos, new_player_grid_pos)
		return true

	return false
