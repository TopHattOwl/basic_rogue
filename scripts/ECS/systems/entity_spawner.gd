class_name EntitySpawner
extends Node

static func spawn_player():
	if GameData.player:
		return
	var player_scene = preload(DirectoryPaths.player_scene)
	GameData.player = player_scene.instantiate()

	

	# give player ui to UiFunc
	UiFunc.set_player_ui()


	# data load
	var json = JSON.parse_string(FileAccess.get_file_as_string(DirectoryPaths.player_data_json))
	SaveFuncs.load_player_data(json)

	# load correct map
	var player_world_pos = GameData.player.PlayerComp.world_map_pos
	WorldMapData.world_map2.enter_world_map(player_world_pos)

	# position set
	var position_comp = ComponentRegistry.get_component(GameData.player, GameData.ComponentKeys.POSITION)
	if position_comp:
		GameData.player.position = MapFunction.to_world_pos(ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos)

		MapFunction.add_player_to_variables(GameData.player)

	else:
		push_error("Player position component not found")
	

	GameData.main_node.add_child(GameData.player)
	GameData.player.owner = GameData.main_node # for scene persistence
	
	# upate/set camera zoom and limints
	UiFunc.update_camera_data()


static func spawn_monster(grid_pos: Vector2i, monster_key: int):
	var monster = null

	monster = load(DirectoryPaths.monster_scenes[monster_key]).instantiate()
	var position_comp = ComponentRegistry.get_component(monster, GameData.ComponentKeys.POSITION)

	if position_comp:
		monster.position = MapFunction.to_world_pos(grid_pos)
		position_comp.grid_pos = grid_pos
		MapFunction.add_hostile_to_variables(monster)
	else:
		push_error("Monster position component not found")


	GameData.main_node.add_child(monster)
	monster.owner = GameData.main_node # for scene persistence


# --- ITEMS ---

## Spawns a specific item
static func spawn_item(grid_pos: Vector2i, item_scene_key: int):
	var item = load(DirectoryPaths.item_scenes[item_scene_key]).instantiate()

	var position_comp = ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_POSITION)
	if position_comp:
		# set position
		position_comp.grid_pos = grid_pos
		item.position = MapFunction.to_world_pos(grid_pos)
		position_comp.is_on_ground = true

		# add to GameData map and item variables

		MapFunction.add_item_to_variables(item)

	else:
		push_error("Item position component not found")
	GameData.main_node.add_child(item)
	item.owner = GameData.main_node # for scene persistence

## spawns a random item based on item type given
func spawn_random_item(_item_type: int):
	pass
