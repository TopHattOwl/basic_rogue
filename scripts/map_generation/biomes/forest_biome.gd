class_name ForestBiome
extends Resource

@export var biome_type: int
@export var biome_name: String
@export var grid_pos: Vector2i

var map_rng = RandomNumberGenerator.new()


# varaibles that gets filled when generating
@export var terrain_map: Array


# load data into world Node here and set variables

func _init(_pos: Vector2i = Vector2i.ZERO) -> void:
	pass

func setup(pos: Vector2i = Vector2i.ZERO) -> void:
	biome_type = GameData.WORLD_TILE_TYPES.FOREST
	biome_name = "Forest"
	grid_pos = pos

func load_map() -> void:
	var world_node = load(DirectoryPaths.world).instantiate()
	world_node.init_data_new(make_world_node_data())

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	MapFunction.initialize_map_data()
	GameData.reset_entity_variables()
	GameData.remove_entities_from_tree()

	GameData.terrain_map = terrain_map
	GameData.current_map = world_node
	GameData.main_node.add_child(GameData.current_map)

# generation
func generate_map() -> void:
	map_rng.seed = WorldMapData.world_map2.map_data[grid_pos.y][grid_pos.x].generated_seed
	terrain_map = MapFunction.make_base_terrain_map()

	var savagery = WorldMapData.world_map_savagery[grid_pos.y][grid_pos.x]
	var monster_data = WorldMapData.world_monster_map.map_data[grid_pos.y][grid_pos.x]


	generate_terrain_data(savagery, monster_data)

	var world_node = load(DirectoryPaths.world).instantiate()
	world_node.init_data_new(make_world_node_data())

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	MapFunction.initialize_map_data()
	GameData.reset_entity_variables()
	GameData.remove_entities_from_tree()

	GameData.terrain_map = terrain_map
	WorldMapData.world_map2.map_data[grid_pos.y][grid_pos.x].explored = true
	GameData.current_map = world_node
	GameData.main_node.add_child(GameData.current_map)

func generate_terrain_data(savagery: int, monster_data: WorldMonsterTile) -> void:
	add_walls()
	add_nature()
	# add_forage() # add when implemented foliage
	add_monsters(savagery, monster_data)

# generation helpers

var wall_chance: float = 0.015
func add_walls() -> void:
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if x == 0 or x == GameData.MAP_SIZE.x - 1 or y == 0 or y == GameData.MAP_SIZE.y - 1:
				continue
			if map_rng.randf() < wall_chance:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.WALL, GameData.get_tile_data(GameData.TILE_TAGS.WALL))


var nature_chance: float = 0.02
func add_nature() -> void:
	for y in range(GameData.MAP_SIZE.y):
		for x in range(GameData.MAP_SIZE.x):
			if terrain_map[y][x].tags.has(GameData.TILE_TAGS.WALL):
				continue
			if map_rng.randf() < nature_chance:
				add_terrain_map_data(Vector2i(x, y), GameData.TILE_TAGS.NATURE, GameData.get_tile_data(GameData.TILE_TAGS.NATURE))


func add_forage() -> void:
	pass


func add_monsters(savagery: int, monster_data: WorldMonsterTile) -> void:
	var max_monsters = max(0, savagery - 2)
	var num_of_monsters = 0

	while num_of_monsters < max_monsters:
		var random_pos = Vector2i(map_rng.randi_range(0, GameData.MAP_SIZE.x - 1), map_rng.randi_range(0, GameData.MAP_SIZE.y - 1))
		if terrain_map[random_pos.y][random_pos.x].tags.has(GameData.TILE_TAGS.WALL):
			continue
		monster_data.spawn_points.append(random_pos)
		num_of_monsters += 1
	print(monster_data)

	if savagery > 10:
		monster_data.has_dungeon = true

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

func load():
	pass

func render():
	pass


var tileset_resource =  {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "res://resources/tiles/biome_sets/field/field_stair_tileset.tres",
		GameData.TILE_TAGS.DOOR: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.DOOR_FRAME: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.NATURE: "res://resources/tiles/biome_sets/field/field_nature_tileset.tres",
		GameData.TILE_TAGS.WALL: "res://resources/tiles/biome_sets/field/field_wall_tileset.tres",
	}

var tile_set_draw_data ={
	GameData.TILE_TAGS.FLOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.WALL: {
		"source_id": 1,
		"atlas_coords_max": Vector2i(0, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.STAIR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.DOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(0, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.DOOR_FRAME: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 0), 
		"atlas_coords_min": Vector2i(1, 0),
	},
	GameData.TILE_TAGS.NATURE: {
		"source_id": 2,
		"atlas_coords_max": Vector2i(0, 0), 
		"atlas_coords_min": Vector2i(1, 0),
	},
}
