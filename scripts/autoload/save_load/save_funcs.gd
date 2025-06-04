extends Node

# # player
# var save_player = preload(DirectoryPaths.save_player).new()
# var load_player = preload(DirectoryPaths.load_player).new()

# # world map
# var save_world_map = preload(DirectoryPaths.save_world_map).new()
# var load_world_map = preload(DirectoryPaths.load_world_map).new()


func save_player_data(player_node: Node2D):

	SavePlayer.save_player_data(player_node)


func load_player_data(json):
	LoadPlayer.load_player_data(json)


func save_world_map_data():
	# saves stuff that are simple variables
	SaveWorldMap.save_biome_type_data()
	SaveWorldMap.save_world_map_savagery()
	SaveWorldMap.save_world_map_civilization()

	# saves custom classes
	SaveWorldMap.save_world_maps()

func load_base_world_map_data():
	# loads stuff that are simple variables
	LoadWorldMap.load_biome_type_data()
	LoadWorldMap.load_world_map_savagery()
	LoadWorldMap.load_world_map_civilization()

	# loads custom classes
	LoadWorldMap.load_world_maps()

# # new world map load
# func load_world_maps() -> void:
# 	LoadWorldMap.load_world_maps()

# # new world map save
# func save_world_maps() -> void:
# 	SaveWorldMap.save_world_maps()
