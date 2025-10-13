class_name Dungeon
extends Resource

var id: int
var levels: Array[DungeonLevel] = []
var world_map_pos: Vector2i

var rng = RandomNumberGenerator.new()

var tileset_resource: Dictionary
var tile_set_draw_data: Dictionary

func _init(data: Dictionary = {}) -> void:
	id = data.get("id", -1)
	rng.seed = data.get("rng_seed", 5)
	world_map_pos = data.get("world_map_pos", Vector2i.ZERO)

	if not check_data(data):
		push_error("dungeon data is missing required fields\ndata: ", data)
		return

	# call overriden methods to set all draw data
	set_draw_data()
	make_levels()

# overriden in child classes
func make_levels() -> void:
	pass

# overriden in child classes
func set_draw_data() -> void:
	pass

func make_dungeon_node_data(level: int = 0) -> Dictionary:
	return {
		"terrain_map": levels[level].terrain_map,
		"tileset_resource": tileset_resource,
		"tile_set_draw_data": tile_set_draw_data,
		"rng": levels[level].rng,
		"stair_up": levels[level].stair_up,
		"stair_down": levels[level].stair_down,
	}


## enter the first level of the dungeon
func enter_dungeon() -> void:
	enter_dungeon_level(0)
	# if GameData.dungeon_debug:
	# 	print("entering dungeon:\n\tid: {0}\n\tworld map pos: {1}".format([id, world_map_pos]))
	# 	print("\tdungeon_type: ", get_script().get_global_name())

	# var _dungeon_node = load(DirectoryPaths.dungeon).instantiate()
	# _dungeon_node.init_data(make_dungeon_node_data())
	# GameData.current_dungeon = _dungeon_node
	# GameData.current_dungeon_class = self

	# if GameData.current_map:
	# 	GameData.current_map.queue_free()
	# 	GameData.current_map = null
	# GameData.remove_entities()

	# GameData.terrain_map = levels[0].terrain_map

	# # put player in right position
	# var spawn_pos = levels[0].stair_up.spawn_pos
	# GameData.player.position = MapFunction.to_world_pos(spawn_pos)
	# GameData.player.PositionComp.grid_pos = spawn_pos

	# GameData.player.PlayerComp.is_in_dungeon = true
	# GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.DUNGEON_INPUT
	# GameData.main_node.add_child(GameData.current_dungeon)

## exits the dungeon
func exit_dungeon() -> void:
	if GameData.current_dungeon:
		GameData.current_dungeon.queue_free()
		GameData.current_dungeon = null
	
	var player_comp: PlayerComponent = GameData.player.PlayerComp
	var world_pos = player_comp.world_map_pos
	var dungeon_pos = WorldMapData.biome_map.get_dungeon_pos(world_pos)

	var new_player_grid_pos = MapFunction.get_tiles_in_radius(dungeon_pos, 1, false, false, "chebyshev", true, true)[0]
	
	GameData.current_dungeon_class = null
	GameData.player.PlayerComp.is_in_dungeon = false
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos = new_player_grid_pos
	GameData.player.position = MapFunction.to_world_pos(new_player_grid_pos)
	WorldMapData.biome_map.generate_map(world_pos)


func enter_dungeon_level(level: int) -> void:
	if GameData.dungeon_debug and level == 0:
		print("entering dungeon:\n\tid: {0}\n\tworld map pos: {1}".format([id, world_map_pos]))
		print("\tdungeon_type: ", get_script().get_global_name())
	elif GameData.dungeon_debug:
		print("entering dungeon level: {0}".format([level]))
	
	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	GameData.remove_entities()

	if GameData.current_dungeon:
		GameData.current_dungeon.queue_free()
		GameData.current_dungeon = null
	
	var _dungeon_node = load(DirectoryPaths.dungeon).instantiate()
	_dungeon_node.init_data(make_dungeon_node_data(level))
	GameData.current_dungeon = _dungeon_node
	GameData.current_dungeon_class = self

	GameData.terrain_map = levels[level].terrain_map

	# put player in right position
	var spawn_pos = levels[level].stair_up.spawn_pos
	GameData.player.position = MapFunction.to_world_pos(spawn_pos)
	GameData.player.PositionComp.grid_pos = spawn_pos

	GameData.player.PlayerComp.is_in_dungeon = true
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.DUNGEON_INPUT
	GameData.main_node.add_child(GameData.current_dungeon)
	
# --- Checks ---

func check_data(data: Dictionary) -> bool:
	return check_id(data) and check_world_map_pos(data) and check_rng_seed(data)

func check_id(data: Dictionary) -> bool:
	return data.has("id")

func check_world_map_pos(data: Dictionary) -> bool:
	return data.has("world_map_pos")

func check_rng_seed(data: Dictionary) -> bool:
	return data.has("rng_seed")
