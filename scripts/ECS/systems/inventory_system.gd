class_name InventorySystem
extends Node

static func pick_up_item(pos: Vector2i):
	var items = GameData.items_map[pos.y][pos.x]
	# var item_window = load(DirectoryPaths.pick_up_window_scene).instantiate()
	# item_window.add_items(items)
	# GameData.main_node.add_child(item_window)
	

	for item in items:
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.INVENTORY).add_item_to_inventory(item) # add_to_inventory()
		# item.visible = false
		MapFunction.remove_item_from_variables(item)
	
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true