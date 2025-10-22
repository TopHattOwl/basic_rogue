extends Node


## Drop an item at position
func drop_item(_item: ItemResource, grid_pos: Vector2i) -> void:
	pass


func pick_up_specific_item(_item: ItemResource, grid_pos: Vector2i, _entity: Node2D) -> void:
	pass

func pick_up_all_items(grid_pos: Vector2i, _entity: Node2D) -> void:
	pass


## Get all items at a grid position (for UI display)
func get_items_at(grid_pos: Vector2i) -> Array[ItemResource]:

	if not has_items_at(grid_pos):
		return []
	var items: Array[ItemResource] = GameData.items_map[grid_pos]
	return items


## Check if there are items at a position
func has_items_at(grid_pos: Vector2i) -> bool:
	var items_on_ground: Array[ItemResource] = GameData.items_map[grid_pos]
	return not items_on_ground.is_empty()


## Get count of items at position
func get_item_count_at(grid_pos: Vector2i) -> int:
	if not has_items_at(grid_pos):
		return 0

	var items_on_ground = GameData.items_map[grid_pos]
	return items_on_ground.size()


## Remove specific item from ground (for destruction, not pickup)
func remove_item(grid_pos: Vector2i, item: ItemResource) -> void:
	pass


## Clear all items at a position
func clear_position(grid_pos: Vector2i) -> void:
	var items_map = GameData.items_map
	items_map[grid_pos] = []


## Clear all items (for scene transitions)
func clear_all() -> void:
	GameData.items_map.clear()