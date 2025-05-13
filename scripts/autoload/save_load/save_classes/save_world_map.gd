class_name SaveWorldMap
extends Node


func save_world_map_data():
	var file = FileAccess.open_compressed(DirectoryPaths.world_map_data_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map)
	file.close()

func save_biome_type_data():
	var file = FileAccess.open_compressed(DirectoryPaths.biome_type_world_map_data_save, FileAccess.WRITE)
	file.store_var(WorldMapData.biome_type)
	file.close()

func save_world_map_monster_data():
	var file = FileAccess.open_compressed(DirectoryPaths.monster_world_map_data_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_monster_data)
	file.close()