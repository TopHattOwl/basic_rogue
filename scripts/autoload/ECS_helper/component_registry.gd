extends Node

func get_component(entity: Node, component_key: int) -> Node:

	var path = GameData.COMPONENTS[component_key]
	return entity.get_node(path) if entity.has_node(path) else null

func get_player_comp(component_key: int) -> Node:
	return get_component(GameData.player, component_key)


func init_weapon_components(weapon_node: Node2D, d: Dictionary) ->void:

	weapon_node.item_identity_comp.initialize(d[GameData.ComponentKeys.ITEM_IDENTITY])
	weapon_node.weapon_stats_comp.initialize(d[GameData.ComponentKeys.WEAPON_STATS])
	weapon_node.item_skill_comp.initialize(d[GameData.ComponentKeys.ITEM_SKILL])
	pass
