extends Node

# player
var save_player = preload(DirectoryPaths.save_player).new()
var load_player = preload(DirectoryPaths.load_player).new()

# world map
var save_world_map = preload(DirectoryPaths.save_world_map).new()
var load_world_map = preload(DirectoryPaths.load_world_map).new()


func save_player_data(player_node: Node2D):

	save_player.save_player_data(player_node)


func load_player_data(json):
	load_player.load_player_data(json)


# world map
func save_world_map_data():
	save_world_map.save_world_map_data()
	save_world_map.save_biome_type_data()
	save_world_map.save_world_map_monster_data()

func load_world_map_data():
	load_world_map.load_world_map_data()
	load_world_map.load_biome_type_data()
	load_world_map.load_world_map_monster_data()
