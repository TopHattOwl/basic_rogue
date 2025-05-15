class_name EntitySpawner
extends Node

var main_node: Node2D


func spawn_player():
	if GameData.player:
		return
	var player_scene = preload(DirectoryPaths.player_scene)
	GameData.player = player_scene.instantiate()

	GameData.main_node.add_child(GameData.player)
	GameData.player.owner = main_node # for scene persistence

	# give player ui to UiFunc
	UiFunc.set_player_ui()


	# data load
	var json = JSON.parse_string(FileAccess.get_file_as_string(DirectoryPaths.player_data_json))
	SaveFuncs.load_player_data(json)

	var position_comp = ComponentRegistry.get_component(GameData.player, GameData.ComponentKeys.POSITION)
	if position_comp:
		GameData.player.position = MapFunction.to_world_pos(ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos)

		MapFunction.add_player_to_variables(GameData.player)

	else:
		push_error("Player position component not found")


func spawn_monster(grid_pos: Vector2i, monster_key: int, monster_tier: int = 1):
	var monster = null
	match monster_tier:
		1:
			monster = load(DirectoryPaths.monsters1_scenes[monster_key]).instantiate()
			var position_comp = ComponentRegistry.get_component(monster, GameData.ComponentKeys.POSITION)

			if position_comp:
				monster.position = MapFunction.to_world_pos(grid_pos)
				position_comp.grid_pos = grid_pos
				MapFunction.add_hostile_to_variables(monster)
			else:
				push_error("Monster position component not found")
		2:
			pass

	GameData.main_node.add_child(monster)
	monster.owner = main_node # for scene persistence

	# var monster = load(DirectoryPaths.monsters1_scenes[monster_key]).instantiate()
	# var monster_data = DataRegistry.monsters1[monster_key]

	# init_monster_components(monster, monster_data)

	# var position_comp = ComponentRegistry.get_component(monster, GameData.ComponentKeys.POSITION)

	# if position_comp:
	# 	# set position
	# 	position_comp.grid_pos = grid_pos
	# 	monster.position = MapFunction.to_world_pos(grid_pos)

	# 	# set monster_id
	# 	var monster_stats_comp = ComponentRegistry.get_component(monster, GameData.ComponentKeys.MONSTER_STATS)
	# 	monster_stats_comp.monster_id = monster_key

	# 	MapFunction.add_hostile_to_variables(monster)

	# else:
	# 	push_error("Monster position component not found")
	

	# GameData.main_node.add_child(monster)
	# monster.owner = main_node # for scene persistence


func init_monster_components(monster: Node2D, monster_data: Dictionary):
	# health component
	var health = monster.get_node(GameData.get_component_path(GameData.ComponentKeys.HEALTH))
	health.initialize(monster_data.health_component.max_hp)

	# attributes component
	var attributes = monster.get_node(GameData.get_component_path(GameData.ComponentKeys.ATTRIBUTES))
	attributes.initialize(monster_data.attributes_component)

	# identity component
	var identity = monster.get_node(GameData.get_component_path(GameData.ComponentKeys.IDENTITY))
	identity.initialize(monster_data.identity_component)

	# melee combat component
	var melee_combat = monster.get_node(GameData.get_component_path(GameData.ComponentKeys.MELEE_COMBAT))
	melee_combat.initialize(monster_data.melee_combat_component)

	# monster stats component
	var monster_stats = monster.get_node(GameData.get_component_path(GameData.ComponentKeys.MONSTER_STATS))
	monster_stats.initialize(monster_data.monster_stats_component)

	# ai behavior component
	var ai_behavior = monster.get_node(GameData.get_component_path(GameData.ComponentKeys.AI_BEHAVIOR))
	ai_behavior.initialize(monster_data.ai_behavior_component)

# --- ITEMS ---

## Spawns a specific item
func spawn_item(grid_pos: Vector2i, item_scene_key: int):
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
	main_node.add_child(item)
	item.owner = main_node # for scene persistence

## spawns a random item based on item type given
func spawn_random_item(_item_type: int):
	pass
