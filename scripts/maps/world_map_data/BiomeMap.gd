class_name BiomeMap
extends Resource

## Each element in the map_data will be a Biome tile (see scripts/map_generation/biomes)
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


func get_dungeon_pos(world_pos: Vector2i) -> Vector2i:
	return map_data[world_pos.y][world_pos.x].dungeon_pos

# SAVE/LOAD

# func save_biome_map() -> void:
# 	ResourceSaver.save(self, SavePaths.biome_map_save)

# func load_biome_map() -> void:
# 	var loader := ResourceLoader.load(
# 		SavePaths.biome_map_save,
# 		"",
# 		ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
# 	) as BiomeMap

# 	if loader == null:
# 		push_error("Failed to load BiomeMap")
# 		return
	
# 	map_data = loader.map_data


# BASE SAVES
func save_base_biome_map() -> void:
	ResourceSaver.save(self, DirectoryPaths.biome_map_base_save)


func load_base_biome_map() -> void:
	if ResourceLoader.exists(DirectoryPaths.biome_map_base_save):
		var loaded_data = ResourceLoader.load(
			DirectoryPaths.biome_map_base_save,
			"",
			ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
		)
		map_data = loaded_data.map_data
