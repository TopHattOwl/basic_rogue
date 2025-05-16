class_name MapGenerator
extends Node


# genrates random surface map
# generation is handled in world.gd and here both

# generation steps:
	# init with all floor tile (each tile is random from given tileset)
	# generate map data matching biome type
	# generate monster related stuff based on savagery and world map monster data
	# make copy of world Node and set it to current map
	# set variables
	# add as a child into main node


## Generates random map, sets variables, loads map
func generate_random_map(world_map_pos: Vector2i) -> void:
	print("generating random map at pos: ", world_map_pos)
	var terrain_map = MapFunction.make_base_terrain_map()

	# getting data
	var savagery = WorldMapData.world_map_savagery[world_map_pos.y][world_map_pos.x]
	var monster_data = WorldMapData.world_map_monster_data[world_map_pos.y][world_map_pos.x]
	var biome_type = WorldMapData.biome_type[world_map_pos.y][world_map_pos.x]

	# get tilesets
	var tile_sets = get_tile_sets(biome_type)

	var world_node_data = {
		"terrain_map": terrain_map,
		"tile_sets": tile_sets,
		"world_map_pos": world_map_pos,
		"savagery": savagery,
		"monster_data": monster_data,
		"biome_type": biome_type,
	}

	# init world_node, set its data
	var world_node = load(DirectoryPaths.world).instantiate()
	world_node.init_data(world_node_data)
	world_node.generate_terrain_data()

	
	# variables handling
	set_variables(world_node)


func get_tile_sets(biome_type: int) -> Dictionary:
	var tile_sets = {
		GameData.TILE_TAGS.FLOOR: load(DirectoryPaths.BiomeTileSets[biome_type][GameData.TILE_TAGS.FLOOR]),
		GameData.TILE_TAGS.STAIR: load(DirectoryPaths.BiomeTileSets[biome_type][GameData.TILE_TAGS.STAIR]),
		GameData.TILE_TAGS.DOOR: load(DirectoryPaths.BiomeTileSets[biome_type][GameData.TILE_TAGS.DOOR]),
		GameData.TILE_TAGS.DOOR_FRAME: load(DirectoryPaths.BiomeTileSets[biome_type][GameData.TILE_TAGS.DOOR_FRAME]),
		GameData.TILE_TAGS.NATURE: load(DirectoryPaths.BiomeTileSets[biome_type][GameData.TILE_TAGS.NATURE]),
		GameData.TILE_TAGS.WALL: load(DirectoryPaths.BiomeTileSets[biome_type][GameData.TILE_TAGS.WALL]),
	}
	return tile_sets

func set_variables(map_node: Node2D) -> void:
	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	# reset variables
	MapFunction.initialize_map_data()
	GameData.reset_entity_variables()

	GameData.current_map = map_node
	GameData.main_node.add_child(GameData.current_map)
