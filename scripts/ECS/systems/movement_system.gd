class_name MovementSystem
extends Node

# this main_node variable is set in main_node.gd's ready function by entity_systems.gd
var main_node: Node2D

## attemps to move entity to new_pos, returns true if successful
func process_movement(entity: Node, new_pos: Vector2i) -> bool:

	var position_component = ComponentRegistry.get_component(entity, GameData.ComponentKeys.POSITION)

	if not position_component:
		push_error("No position component found for entity: ", entity.name)
		return false
	
	# check if there is actor at pos and if they are of the same faction
	var faction = ComponentRegistry.get_component(entity, GameData.ComponentKeys.IDENTITY).faction
	var actor_at_pos = GameData.actors_map[new_pos.y][new_pos.x]


	if actor_at_pos:
		if faction != ComponentRegistry.get_component(actor_at_pos, GameData.ComponentKeys.IDENTITY).faction:
			return EntitySystems.combat_system.melee_attack(entity, actor_at_pos)

	# if actor_at_pos != null:
	# 	if faction != ComponentRegistry.get_component(actor_at_pos, GameData.ComponentKeys.IDENTITY).faction:
	# 		return EntitySystemsManager.combat_system.melee_attack(entity, actor_at_pos)

	if MapFunction.is_tile_walkable(new_pos) and MapFunction.is_in_bounds(new_pos):
		
		var old_pos = position_component.grid_pos
		# update component
		position_component.grid_pos = new_pos

		# update variables
		GameData.actors_map[old_pos.y][old_pos.x] = null
		GameData.actors_map[new_pos.y][new_pos.x] = entity


		# visual update
		entity.position = MapFunction.to_world_pos(new_pos)
		return true

	return false

func process_stairs(entity: Node) -> void:
	
	
	pass
