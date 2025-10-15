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
	var tile: WorldMapTile = map_data[pos.y][pos.x]
	tile.add_premade_map(path)


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
			


# --- SAVE/LOAD ---

# func save_world_map() -> void:
# 	ResourceSaver.save(self, SavePaths.world_map_save)
# 	if GameData.save_load_debug:
# 		print("saving world map class here: ", SavePaths.world_map_save)

# func load_world_map() -> void:
# 	var loader := ResourceLoader.load(
# 		SavePaths.world_map_save,
# 		"",
# 		ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
# 	) as WorldMap

# 	if loader == null:
# 		push_error("Failed to load WorldMap")
# 		return
	
# 	map_data = loader.map_data

## saves exlored tiles for map [br]
## only saves it to the varable, does not write save file
func save_explored_tiles(world_pos: Vector2i, tiles: Array) -> void:
	var tile: WorldMapTile = map_data[world_pos.y][world_pos.x]
	tile.save_explored_tiles(tiles)

func get_explored_tiles(world_pos: Vector2i) -> Array:
	return map_data[world_pos.y][world_pos.x].explored_tiles.duplicate()



# BASE SAVES
# save and load the WorldMap to save files
func save_base_world_map() -> void:
	ResourceSaver.save(self, DirectoryPaths.world_map_base_save)

func load_base_world_map() -> void:
	if ResourceLoader.exists(DirectoryPaths.world_map_base_save):
		var loaded_data = ResourceLoader.load(
			DirectoryPaths.world_map_base_save,
			"",
			ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
		)
		map_data = loaded_data.map_data
