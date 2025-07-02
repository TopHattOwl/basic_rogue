extends Node

func get_component(entity: Node, component_key: int) -> Node:

	var path = GameData.COMPONENTS[component_key]
	return entity.get_node(path) if entity.has_node(path) else null

func get_player_comp(component_key: int) -> Node:
	return get_component(GameData.player, component_key)

func get_player_pos() -> Vector2i:
	return get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
