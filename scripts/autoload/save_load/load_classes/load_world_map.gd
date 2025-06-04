class_name LoadWorldMap
extends Node

static func load_biome_type_data():
	if FileAccess.file_exists(DirectoryPaths.biome_type_world_map_data_save):
		var file = FileAccess.open_compressed(DirectoryPaths.biome_type_world_map_data_save, FileAccess.READ)
		WorldMapData.biome_type = file.get_var()
		file.close()


static func load_world_map_savagery():
	if FileAccess.file_exists(DirectoryPaths.world_map_savagery_save):
		var file = FileAccess.open_compressed(DirectoryPaths.world_map_savagery_save, FileAccess.READ)
		WorldMapData.world_map_savagery = file.get_var()
		file.close()

static func load_world_map_civilization():
	if FileAccess.file_exists(DirectoryPaths.world_map_civilization_save):
		var file = FileAccess.open_compressed(DirectoryPaths.world_map_civilization_save, FileAccess.READ)
		WorldMapData.world_map_civilization = file.get_var()
		file.close()

static func load_world_maps() -> void:
	WorldMapData.world_map2.load_world_map()
	WorldMapData.biome_map.load_biome_map()
	WorldMapData.world_monster_map.load_world_monster_map()