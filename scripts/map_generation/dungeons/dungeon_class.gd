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
		"rng": levels[level].rng
	}


## enter the first level of the dungeon
func enter_dungeon() -> void:
	if GameData.dungeon_debug:
		print("entering dungeon:\n\tid: {0}\n\tworld map pos: {1}".format([id, world_map_pos]))
		print("\tdungeon_type: ", get_script().get_global_name())

	var _dungeon_node = load(DirectoryPaths.dungeon).instantiate()
	_dungeon_node.init_data(make_dungeon_node_data())
	GameData.current_dungeon = _dungeon_node

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	GameData.remove_entities()

	GameData.terrain_map = levels[0].terrain_map

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
