class_name WorldMonsterMap
extends Resource

@export var map_data: Array[Array]

func _init() -> void:
    map_data = []

    for y in range(GameData.WORLD_MAP_SIZE.y):
        map_data.append([])
        for x in range(GameData.WORLD_MAP_SIZE.x):
            map_data[y].append(null)



# SAVE/LOAD

func save_world_monster_map() -> void:
    ResourceSaver.save(self, SavePaths.world_monster_map_save)

func load_world_monster_map() -> void:
    if ResourceLoader.exists(SavePaths.world_monster_map_save):
        var loaded_data = ResourceLoader.load(
            SavePaths.world_monster_map_save,
            "",
            ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
        )
        map_data = loaded_data.map_data

# BASE SAVES

func save_base_world_monster_map() -> void:
    ResourceSaver.save(self, DirectoryPaths.world_monster_map_base_save)

func load_base_world_monster_map() -> void:
    if ResourceLoader.exists(DirectoryPaths.world_monster_map_base_save):
        var loaded_data = ResourceLoader.load(
            DirectoryPaths.world_monster_map_base_save,
            "",
            ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
        )
        map_data = loaded_data.map_data