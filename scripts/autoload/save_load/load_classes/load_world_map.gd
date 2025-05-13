class_name LoadWorldMap
extends Node

func load_world_map_data():
    if FileAccess.file_exists(DirectoryPaths.world_map_data_save):
        var file = FileAccess.open_compressed(DirectoryPaths.world_map_data_save, FileAccess.READ)
        WorldMapData.world_map = file.get_var()
        file.close()

func load_biome_type_data():
    if FileAccess.file_exists(DirectoryPaths.biome_type_world_map_data_save):
        var file = FileAccess.open_compressed(DirectoryPaths.biome_type_world_map_data_save, FileAccess.READ)
        WorldMapData.biome_type = file.get_var()
        file.close()

func load_world_map_monster_data():
    if FileAccess.file_exists(DirectoryPaths.monster_world_map_data_save):
        var file = FileAccess.open_compressed(DirectoryPaths.monster_world_map_data_save, FileAccess.READ)
        WorldMapData.world_map_monster_data = file.get_var()
        file.close()