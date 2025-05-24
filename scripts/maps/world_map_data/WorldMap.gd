class_name WorldMap
extends Resource

# World map tile object is the value of each WorldMap[y][x]
@export var map_data: Array[Array]



func _init() -> void:
	map_data = []

	for y in range(GameData.WORLD_MAP_SIZE.y):
		map_data.append([])
		for x in range(GameData.WORLD_MAP_SIZE.x):
			var map_tile = WorldMapTile.new()
			map_tile.setup(Vector2i(x, y))
			map_data[y].append(map_tile)

func add_premade_map(path: String, pos: Vector2i) -> void:
	map_data[pos.y][pos.x].add_premade_map(path)


func reset_tile(pos: Vector2i) -> void:
	map_data[pos.y][pos.x] = WorldMapTile.new(pos)


# utils
func is_tile_walkable(pos: Vector2i) -> bool:
	return map_data[pos.y][pos.x].walkable

func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GameData.WORLD_MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.WORLD_MAP_SIZE.y


func enter_world_map(world_pos: Vector2i) -> void:
	if map_data[world_pos.y][world_pos.x].is_premade:
		MapFunction.load_premade_map(map_data[world_pos.y][world_pos.x].map_path)
	else:
		if map_data[world_pos.y][world_pos.x].explored:
			WorldMapData.biome_map.map_data[world_pos.y][world_pos.x].load_map()
		else:
			WorldMapData.biome_map.map_data[world_pos.y][world_pos.x].generate_map()
			


# save/load
func save_world_map() -> void:
	ResourceSaver.save(self, DirectoryPaths.world_map_save)

func load_world_map() -> void:
	var loader := ResourceLoader.load(
		DirectoryPaths.world_map_save,
		"",
		ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
	) as WorldMap

	if loader == null:
		push_error("Failed to load BiomeMap")
		return
	
	map_data = loader.map_data
