extends Node

var loot_renderer: LootOnGroundRenderer

func _ready() -> void:
	loot_renderer = LootOnGroundRenderer.new()

## Drop an item at position
func drop_item(_item: ItemResource, grid_pos: Vector2i) -> void:
	var _items_map: Dictionary = GameData.items_map

	# create empty list if it does not exists
	if not _items_map.has(grid_pos):
		_items_map[grid_pos] = []

	add_item_to_pos(_item, grid_pos)

	SignalBus.item_dropped.emit(_item, grid_pos)

## Removes specific item from ground from GameData.items_map
func remove_item(_grid_pos: Vector2i, _item: ItemResource) -> void:
	var _items_map: Dictionary = GameData.items_map

	var items: Array = _items_map[_grid_pos]

	items.erase(_item)

	if items.is_empty():
		_items_map.erase(_grid_pos)
		SignalBus.all_items_picked_up.emit(_grid_pos)

func add_item_to_pos(_item_to_add: ItemResource, grid_pos: Vector2i) -> void:
	var _items: Array = GameData.items_map[grid_pos]

	var item_to_add_id: int = _item_to_add.id


	# check if same item is already there
	var item_already_there: ItemResource = has_item_id(_items, item_to_add_id)
	if item_already_there:
		
		# if not stackable, just add the new item
		var stackable_comp: StackableComponent = _item_to_add.get_component(StackableComponent)
		if not stackable_comp.is_stackable:
			_items.append(_item_to_add)
			return
		
		# if stackable, add to stack
		var amount = _item_to_add.get_component(StackableComponent).count
		item_already_there.get_component(StackableComponent).count += amount
		return
	

	# item with same id is not there just add
	_items.append(_item_to_add)


## pick up for AI
## not used yet
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
		open_pick_up_window(lootable_tiles[0])
		return

	# multiple tiles -> set input mode and let input manager handle it
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.GATHER_DIRECTION
	var avalible_tiles_scene = load(DirectoryPaths.available_tile_scene)
	var _avalible_tiles_node: AvailableTilesNode = avalible_tiles_scene.instantiate()
	_avalible_tiles_node.set_avalible_tiles(lootable_tiles)

	GameData.main_node.add_child(_avalible_tiles_node)



## Picks up a specific item
func pick_up_specific_item(_item: ItemResource, _grid_pos: Vector2i, _entity: Node2D) -> void:
	var inventory_comp: InventoryComponent = _entity.get_component(GameData.ComponentKeys.INVENTORY)
	inventory_comp.add_item(_item)

	# remove item from item_map
	remove_item(_grid_pos, _item)

	SignalBus.item_picked_up.emit(_item, _grid_pos, _entity)


func pick_up_all_items(_grid_pos: Vector2i, _entity: Node2D) -> void:
	var _items_map = GameData.items_map
	var items: Array = GameData.items_map[_grid_pos]
	var inventory_comp: InventoryComponent = _entity.get_component(GameData.ComponentKeys.INVENTORY)

	for item in items:
		inventory_comp.add_item(item)

	# remove items from item_map
	_items_map.erase(_grid_pos)

	SignalBus.all_items_picked_up.emit(_grid_pos)
	

## Remove specific item from ground (for destruction, not pickup)
func destroy_item(_grid_pos: Vector2i, _item: ItemResource) -> void:
	pass


func open_pick_up_window(grid_pos: Vector2i) -> void:
	print("[ItemDropManager] open pick up window for pos: ", grid_pos)
	print("[ItemDropManager] items at pos: ")

	var player_comp: PlayerComponent = GameData.player.PlayerComp
	player_comp.input_mode = GameData.INPUT_MODES.PICK_UP_WINDOW

	var items: Array = GameData.items_map[grid_pos]

	for item in items:
		print("\t", item.display_name)

	var pick_up_window: PickUpWindowControlNode = load(DirectoryPaths.pick_up_window_scene).instantiate()
	pick_up_window.setup(items, grid_pos)
	UiFunc.player_ui.add_child(pick_up_window)


## Clear all items at a position
func clear_position(grid_pos: Vector2i) -> void:
	var items_map = GameData.items_map
	items_map[grid_pos] = []


## Clear all items (for scene transitions)
func clear_all() -> void:
	GameData.items_map.clear()

## checks if item id is in the list and returns it.
func has_item_id(_items: Array, item_id: int) -> ItemResource:
	for item: ItemResource in _items:
		if item.id == item_id:
			return item
	return null
