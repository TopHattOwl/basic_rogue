extends Node


## Drop an item at position
func drop_item(_item: ItemResource, grid_pos: Vector2i) -> void:
	pass


func pick_up_specific_item(_item: ItemResource, grid_pos: Vector2i, _entity: Node2D) -> void:
	pass

func pick_up_all_items(grid_pos: Vector2i, _entity: Node2D) -> void:
	pass


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