extends Node

## Drop an item at position
func drop_item(_item: ItemResource, grid_pos: Vector2i) -> void:
	var _items_map: Dictionary = GameData.items_map

	# create empty list if it does not exists
	if not _items_map.has(grid_pos):
		_items_map[grid_pos] = []
	
	_items_map[grid_pos].append(_item)
	SignalBus.item_dropped.emit(_item, grid_pos)


## pick up for AI
func try_pick_up_at_pos(grid_pos: Vector2i, _entity: Node2D) -> void:
	var _items_map = GameData.items_map

	if not _items_map.has(grid_pos):
		return
	
	if _items_map[grid_pos].is_empty():
		return
	
	if _items_map[grid_pos].size() == 1:
		pick_up_specific_item(_items_map[grid_pos][0], grid_pos, _entity)
		return
	
	pick_up_all_items(grid_pos, _entity)

## Only runs from input manager for player [br]
## Let player pick where to gather the loot [br]
## if only one place where there is loot, pick that
func pick_gather_target() -> void:
	var player_grid = ComponentRegistry.get_player_pos()
	var _items_map = GameData.items_map
	var _tiles = MapFunction.get_tiles_in_radius(player_grid, 1, true, true, "chebyshev", true, false)
	var lootable_tiles = []

	for tile in _tiles:
		if _items_map.has(tile):
			lootable_tiles.append(tile)
	
	if lootable_tiles.is_empty():
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).restore_input_mode()
		return
	
	if lootable_tiles.size() == 1:
		var player_comp: PlayerComponent = GameData.player.PlayerComp
		player_comp.input_mode = GameData.INPUT_MODES.PICK_UP_WINDOW
		open_pick_up_window(lootable_tiles[0])
		return

	# multiple tiles -> set input mode and let input manager handle it
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.GATHER_DIRECTION
	var avalible_tiles_scene = load(DirectoryPaths.available_tile_scene)
	var _avalible_tiles_node: AvailableTilesNode = avalible_tiles_scene.instantiate()
	_avalible_tiles_node.set_avalible_tiles(lootable_tiles)

	GameData.main_node.add_child(_avalible_tiles_node)




func pick_up_specific_item(_item: ItemResource, _grid_pos: Vector2i, _entity: Node2D) -> void:
	pass

func pick_up_all_items(_grid_pos: Vector2i, _entity: Node2D) -> void:
	pass


## Remove specific item from ground (for destruction, not pickup)
func remove_item(_grid_pos: Vector2i, _item: ItemResource) -> void:
	pass


func open_pick_up_window(grid_pos: Vector2i) -> void:
	print("[ItemDropManager] open pick up window for pos: ", grid_pos)
	print("[ItemDropManager] items at pos: ")
	for item in GameData.items_map[grid_pos]:
		print("\t", item.display_name)

	var player_comp: PlayerComponent = GameData.player.PlayerComp
	player_comp.restore_input_mode()


## Clear all items at a position
func clear_position(grid_pos: Vector2i) -> void:
	var items_map = GameData.items_map
	items_map[grid_pos] = []


## Clear all items (for scene transitions)
func clear_all() -> void:
	GameData.items_map.clear()
