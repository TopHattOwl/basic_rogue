class_name SaveWorldMap
extends Node

func save_biome_type_data() -> void:
	var file = FileAccess.open_compressed(DirectoryPaths.biome_type_world_map_data_save, FileAccess.WRITE)
	file.store_var(WorldMapData.biome_type)
	file.close()

func save_world_map_savagery() -> void:
	var file = FileAccess.open_compressed(DirectoryPaths.world_map_savagery_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_savagery)
	file.close()

func save_world_map_civilization() -> void:
	var file = FileAccess.open_compressed(DirectoryPaths.world_map_civilization_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_civilization)
	file.close()


static func save_world_maps() -> void:
	WorldMapData.world_map2.save_world_map()
	WorldMapData.biome_map.save_biome_map()
	WorldMapData.world_monster_map.save_world_monster_map()
