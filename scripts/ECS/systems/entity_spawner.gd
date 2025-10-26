class_name EntitySpawner
extends Node

static func spawn_player() -> void:
	# give player ui to UiFunc
	UiFunc.set_player_ui()

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
	SignalBus.actor_spawned.emit(GameData.player)
	# upate/set camera zoom and limints
	UiFunc.update_camera_data()


static func spawn_monster(grid_pos: Vector2i = Vector2i.ZERO, monster_key: int = 0) -> void:
	var monster: MonsterBase = null

	var monster_data = MonsterDefinitions.monster_definitions[monster_key]

	var monster_type = monster_data.base_data.type

	match monster_type:
		MonsterDefinitions.MONSTER_TYPES.NORMAL:
			monster = MonsterFactory.make_monster(monster_data, MonsterNormal)
		MonsterDefinitions.MONSTER_TYPES.MINIBOSS:
			monster = MonsterFactory.make_monster(monster_data, MonsterMiniboss)
		MonsterDefinitions.MONSTER_TYPES.BOSS:
			monster = MonsterFactory.make_monster(monster_data, MonsterBoss)


	var position_comp = ComponentRegistry.get_component(monster, GameData.ComponentKeys.POSITION)

	if position_comp:
		monster.position = MapFunction.to_world_pos(grid_pos)
		position_comp.grid_pos = grid_pos
		MapFunction.add_hostile_to_variables(monster)
	else:
		push_error("Monster position component not found")


	GameData.main_node.add_child(monster)
	SignalBus.actor_spawned.emit(monster)
	monster.owner = GameData.main_node # for scene persistence


static func spawn_monster_remains(monster: MonsterBase) -> void:
	var position = monster.get_component(GameData.ComponentKeys.POSITION).grid_pos
	var monster_id = monster.id

	var remains = MonsterFactory.make_monster_remains(monster_id)

	ComponentRegistry.get_component(remains, GameData.ComponentKeys.POSITION).grid_pos = position
	remains.position = MapFunction.to_world_pos(position)
	GameData.main_node.add_child(remains)


static func spawn_npc(grid_pos: Vector2i = Vector2i.ZERO, npc_key: int = 0) -> void:

	var npc_data = NpcDefinitions.npc_definitions[npc_key]

	var npc = NPCFactory.make_npc(npc_data)

	var position_comp = ComponentRegistry.get_component(npc, GameData.ComponentKeys.POSITION)

	if position_comp:
		npc.position = MapFunction.to_world_pos(grid_pos)
		position_comp.grid_pos = grid_pos
		MapFunction.add_friendly_to_variables(npc)
	else:
		push_error("NPC position component not found")


	GameData.main_node.add_child(npc)
	SignalBus.actor_spawned.emit(npc)
	npc.owner = GameData.main_node # for scene persistence



# --- ITEMS ---

## Spawns a specific item [br]
## Based on given 

# decrepit
static func spawn_item(_grid_pos: Vector2i, _item_uid: String):
	pass

## spawns a random item based on item type given
func spawn_random_item(_item_type: int):
	pass
