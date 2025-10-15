class_name SaveWorldMap
extends Node


static func save_biome_type_data() -> void:
	var file = FileAccess.open_compressed(SavePaths.biome_type_world_map_data_save, FileAccess.WRITE)
	file.store_var(WorldMapData.biome_type)
	file.close()

static func save_world_map_savagery() -> void:
	var file = FileAccess.open_compressed(SavePaths.world_map_savagery_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_savagery)
	file.close()

static func save_world_map_civilization() -> void:
	var file = FileAccess.open_compressed(SavePaths.world_map_civilization_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_civilization)
	file.close()


static func save_world_maps() -> void:
	print("[SaveWorldMap] saving all world maps")

	ResourceSaver.save(WorldMapData.world_map2, SavePaths.world_map_save)
	print("[SaveWorldMap] saved world map")
	await Engine.get_main_loop().process_frame

	ResourceSaver.save(WorldMapData.biome_map, SavePaths.biome_map_save)
	print("[SaveWorldMap] saved biome map")
	await Engine.get_main_loop().process_frame

	ResourceSaver.save(WorldMapData.world_monster_map, SavePaths.world_monster_map_save)
	print("[SaveWorldMap] saved world monster map")
	await Engine.get_main_loop().process_frame

	ResourceSaver.save(WorldMapData.dungeons, SavePaths.dungeon_map_save)
	print("[SaveWorldMap] saved dungeons map")
	await Engine.get_main_loop().process_frame


# --- Base Data --- 

static func save_base_biome_type_data() -> void:
	var file = FileAccess.open_compressed(DirectoryPaths.biome_type_world_map_base_data_save, FileAccess.WRITE)
	file.store_var(WorldMapData.biome_type)
	file.close()

static func save_base_world_map_savagery() -> void:
	var file = FileAccess.open_compressed(DirectoryPaths.world_map_savagery_base_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_savagery)
	file.close()

static func save_base_world_map_civilization() -> void:
	var file = FileAccess.open_compressed(DirectoryPaths.world_map_civilization_base_save, FileAccess.WRITE)
	file.store_var(WorldMapData.world_map_civilization)
	file.close()


## saves world map data that changes
static func save_base_world_maps() -> void:
	WorldMapData.world_map2.save_base_world_map()
	WorldMapData.biome_map.save_base_biome_map()
	WorldMapData.world_monster_map.save_base_world_monster_map()
	WorldMapData.dungeons.save_base_dungeon_map()
