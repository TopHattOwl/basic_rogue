class_name BiomeMap
extends Resource

@export var map_data: Array[Array]

func _init() -> void:
	map_data.resize(GameData.WORLD_MAP_SIZE.y)
	for y in range(GameData.WORLD_MAP_SIZE.y):
		map_data[y] = []
		map_data[y].resize(GameData.WORLD_MAP_SIZE.x)


func generate_map(pos: Vector2i) -> void:
	# if tile is explored just load in the data to World node
	if WorldMapData.world_map2.map_data[pos.y][pos.x].explored:
		map_data[pos.y][pos.x].load_map()
	else:
		# if tile is not explored, generate it
		map_data[pos.y][pos.x].generate_map()


func get_biome_type(world_pos: Vector2i) -> int:
	return map_data[world_pos.y][world_pos.x].biome_type

# save/load
func save_biome_map() -> void:
	ResourceSaver.save(self, DirectoryPaths.biome_map_save)


func load_biome_map() -> void:
	if ResourceLoader.exists(DirectoryPaths.biome_map_save):
		var loaded_data = ResourceLoader.load(
			DirectoryPaths.biome_map_save,
			"",
			ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
		)
		map_data = loaded_data.map_data
