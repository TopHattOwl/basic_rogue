class_name Biome
extends Resource


var biome_type: int
var biome_name: String
var grid_pos: Vector2i
var terrain_map: Array

var map_rng = RandomNumberGenerator.new()

var tileset_resource
var tile_set_draw_data

var wall_chance: float = 0.005
var nature_chance: float = 0.008

func setup(_pos: Vector2i = Vector2i.ZERO) -> void:
	pass

func load_map() -> void:
	if GameData.biome_debug:
		print("loading map")
	var world_node = load(DirectoryPaths.world).instantiate()
	world_node.init_data_new(make_world_node_data())

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	GameData.remove_entities()

	GameData.terrain_map = terrain_map
	GameData.current_map = world_node
	GameData.main_node.add_child(GameData.current_map)

# generation
func generate_map() -> void:
	if GameData.biome_debug:
		print("generating map")
	map_rng.seed = WorldMapData.world_map2.map_data[grid_pos.y][grid_pos.x].generated_seed
	terrain_map = MapFunction.make_base_terrain_map()

	generate_terrain_data()

	var world_node = load(DirectoryPaths.world).instantiate()
	world_node.init_data_new(make_world_node_data())

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null

		
	GameData.remove_entities()
	

	GameData.terrain_map = terrain_map
	WorldMapData.world_map2.map_data[grid_pos.y][grid_pos.x].explored = true
	GameData.current_map = world_node
	GameData.main_node.add_child(GameData.current_map)

func generate_terrain_data() -> void:
	add_walls()
	add_nature()
	# add_forage() # add when implemented foliage

	# make dungeon enterance after terrain is built
	make_dungeon()

func add_walls() -> void:
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if x == 0 or x == GameData.MAP_SIZE.x - 1 or y == 0 or y == GameData.MAP_SIZE.y - 1:
				continue
			if map_rng.randf() < wall_chance:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL, GameData.get_tile_data(GameData.TILE_TAGS.WALL))


func add_nature() -> void:
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if terrain_map[y][x].tags.has(GameData.TILE_TAGS.WALL):
				continue
			if x == 0 or x == GameData.MAP_SIZE.x - 1 or y == 0 or y == GameData.MAP_SIZE.y - 1:
				continue
			if map_rng.randf() < nature_chance:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.NATURE, GameData.get_tile_data(GameData.TILE_TAGS.NATURE))


func add_forage() -> void:
	pass

func make_dungeon() -> void:
	if not WorldMapData.world_monster_map.has_dungeon(grid_pos):
		if GameData.biome_debug:
			print("this biome tile has no dugeon")
		return

	var position_found = false

	while !position_found:
		# put dungeon somewhere in the middle
		var random_pos = Vector2i(
			map_rng.randi_range(GameData.MAP_SIZE.x / 4, GameData.MAP_SIZE.x - GameData.MAP_SIZE.x / 4),
			map_rng.randi_range(GameData.MAP_SIZE.y / 4, GameData.MAP_SIZE.y - GameData.MAP_SIZE.y / 4)
		)

		if terrain_map[random_pos.y][random_pos.x].tags.size() > 1:
			continue
		
		position_found = true

		add_terrain_map_data(random_pos, GameData.TILE_TAGS.STAIR, GameData.get_tile_data(GameData.TILE_TAGS.STAIR))


# utils
func add_terrain_map_data(target_pos: Vector2i, tag: int, tile_info: Dictionary) -> void:
	var target_tile = terrain_map[target_pos.y][target_pos.x]
	target_tile["tags"].append(tag)

	# apply most restrictive properties
	target_tile["walkable"] = target_tile["walkable"] and tile_info.walkable
	target_tile["transparent"] = target_tile["transparent"] and tile_info.transparent


func make_world_node_data() -> Dictionary:
	var world_node_data = {
		"terrain_map": terrain_map,
		"tile_sets": tileset_resource,
		"monster_data": WorldMapData.world_monster_map.map_data[grid_pos.y][grid_pos.x],
		"pos": grid_pos,
		"tile_set_draw_data": tile_set_draw_data,
		"rng": map_rng,
	}
	return world_node_data