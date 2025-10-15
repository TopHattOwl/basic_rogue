class_name WorldMonsterMap
extends Resource

@export var map_data: Array[Array]

func _init() -> void:
	map_data = []

	for y in range(GameData.WORLD_MAP_SIZE.y):
		map_data.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			map_data[y].append(null)


func add_dungeon(pos: Vector2i, dungeon_id: int) -> void:
	var tile: WorldMonsterTile = map_data[pos.y][pos.x]
	tile.add_dungeon_tile(dungeon_id)

func enter_dungeon(pos: Vector2i) -> void:
	var tile: WorldMonsterTile = map_data[pos.y][pos.x]
	tile.enter_dungeon()

func has_dungeon(world_pos: Vector2i) -> bool:
	var tile: WorldMonsterTile = map_data[world_pos.y][world_pos.x]
	return tile.has_dungeon

# SAVE/LOAD

# BASE SAVES

func save_base_world_monster_map() -> void:
	ResourceSaver.save(self, DirectoryPaths.world_monster_map_base_save)

func load_base_world_monster_map() -> void:
	if ResourceLoader.exists(DirectoryPaths.world_monster_map_base_save):
		var loaded_data = ResourceLoader.load(
			DirectoryPaths.world_monster_map_base_save,
			"",
			ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
		)
		map_data = loaded_data.map_data
