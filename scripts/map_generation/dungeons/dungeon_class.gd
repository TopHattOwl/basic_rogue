class_name Dungeon
extends Resource

@export var id: int
@export var levels: Array[DungeonLevel] = []
@export var world_map_pos: Vector2i

var rng: RandomNumberGenerator = null
@export var rng_seed: int:
	set(value):
		if not rng:
			rng = RandomNumberGenerator.new()
		rng.seed = value
		rng_seed = value


@export var tileset_resource: Dictionary
@export var tile_set_draw_data: Dictionary

func _init(data: Dictionary = {}) -> void:
	id = data.get("id", -1)
	world_map_pos = data.get("world_map_pos", Vector2i.ZERO)
	rng_seed = data.get("rng_seed", 5)

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

	if GameData.dungeon_debug:
		print("\n=== ENTERING DUNGEON ===")
		print("[Dungeon.enter_dungeon] Dungeon ID: ", id)
		print("[Dungeon.enter_dungeon] World pos: ", world_map_pos)
		print("[Dungeon.enter_dungeon] Dungeon rng_seed: ", rng_seed)
		print("[Dungeon.enter_dungeon] Dungeon rng state: ", rng.state)
		print("[Dungeon.enter_dungeon] dungeon_type: ", get_script().get_global_name())
	

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	GameData.remove_entities()

	if GameData.current_dungeon:
		GameData.current_dungeon.queue_free()
		GameData.current_dungeon = null

	GameData.current_dungeon_class = self

	levels[0].generate_level_terrain()

	var _dungeon_node = load(DirectoryPaths.dungeon).instantiate()
	_dungeon_node.init_data(make_dungeon_node_data())
	GameData.current_dungeon = _dungeon_node
	GameData.current_dungeon_level = 0

	if not GameData.current_dungeon_class:
		GameData.current_dungeon_class = self

	GameData.terrain_map = levels[0].terrain_map

	# put player in right position
	var spawn_pos = levels[0].stair_up.spawn_pos

	GameData.player.position = MapFunction.to_world_pos(spawn_pos)
	GameData.player.PositionComp.grid_pos = spawn_pos

	GameData.player.PlayerComp.is_in_dungeon = true
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.DUNGEON_INPUT

	SignalBus.entered_dungeon.emit({
		"dungeon": self,
	})

	GameData.main_node.add_child(GameData.current_dungeon)

	

## exits the dungeon [br]
## `param level` is the level the player exited from, defaults to level 0
func exit_dungeon(level: int = 0) -> void:
	if GameData.current_dungeon:
		GameData.current_dungeon.queue_free()
		GameData.current_dungeon = null
	
	var player_comp: PlayerComponent = GameData.player.PlayerComp
	var world_pos = player_comp.world_map_pos
	var dungeon_pos = WorldMapData.biome_map.get_dungeon_pos(world_pos)

	# save explored tiles
	FovManager.save_explored_tiles_dungeon(level)


	var new_player_grid_pos := Vector2i(dungeon_pos.x, dungeon_pos.y + 1)
	
	GameData.current_dungeon_class = null
	GameData.current_dungeon_level = -1
	GameData.player.PlayerComp.is_in_dungeon = false
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos = new_player_grid_pos
	GameData.player.position = MapFunction.to_world_pos(new_player_grid_pos)

	SignalBus.exited_dungeon.emit({
		"dungeon": self,
	})

	WorldMapData.biome_map.generate_map(world_pos)



## enters a given level, with an optional direction
func enter_dungeon_level(level: int, direction: String = "down") -> void:
	var old_level = 0
	if GameData.dungeon_debug:
		print("entering dungeon level: {0}".format([level]))
	
	if GameData.current_dungeon:
		GameData.current_dungeon.queue_free()
		GameData.current_dungeon = null
	
	GameData.remove_entities()

	levels[level].generate_level_terrain()

	var _dungeon_node = load(DirectoryPaths.dungeon).instantiate()
	_dungeon_node.init_data(make_dungeon_node_data(level))
	GameData.current_dungeon = _dungeon_node
	GameData.current_dungeon_level = level

	if not GameData.current_dungeon_class:
		GameData.current_dungeon_class = self

	GameData.terrain_map = levels[level].terrain_map

	# put player in right position
	var spawn_pos: Vector2i = Vector2i.ZERO
	match direction:
		"down": # if going down, use the next level's up stair's spawn point
			spawn_pos = levels[level].stair_up.spawn_pos
			old_level = level - 1
		"up":
			spawn_pos = levels[level].stair_down.spawn_pos
			old_level = level + 1

	GameData.player.position = MapFunction.to_world_pos(spawn_pos)
	GameData.player.PositionComp.grid_pos = spawn_pos

	GameData.player.PlayerComp.is_in_dungeon = true
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.DUNGEON_INPUT

	SignalBus.dungeon_level_changed.emit(level, old_level)

	GameData.main_node.add_child(GameData.current_dungeon)

	
	

func get_explored_tiles(level: int) -> Array:
	return levels[level].get_explored_tiles()

func save_explored_tiles(level: int, tiles: Array) -> void:
	levels[level].save_explored_tiles(tiles)

# --- Checks ---

func check_data(data: Dictionary) -> bool:
	return check_id(data) and check_world_map_pos(data) and check_rng_seed(data)

func check_id(data: Dictionary) -> bool:
	return data.has("id")

func check_world_map_pos(data: Dictionary) -> bool:
	return data.has("world_map_pos")

func check_rng_seed(data: Dictionary) -> bool:
	return data.has("rng_seed")
