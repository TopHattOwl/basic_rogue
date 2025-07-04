class_name WorldMonsterMap
extends Resource

@export var map_data: Array[Array]

func _init() -> void:
    map_data = []

    for y in range(GameData.WORLD_MAP_SIZE.y):
        map_data.append([])
        for x in range(GameData.WORLD_MAP_SIZE.x):
            map_data[y].append(null)


func save_world_monster_map() -> void:
    ResourceSaver.save(self, DirectoryPaths.world_monster_map_save)

func load_world_monster_map() -> void:
    if ResourceLoader.exists(DirectoryPaths.world_monster_map_save):
        var loaded_data = ResourceLoader.load(
            DirectoryPaths.world_monster_map_save,
            "",
            ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
        )
        map_data = loaded_data.map_data


func get_monster_ids(world_pos: Vector2i) -> Array:
    return map_data[world_pos.y][world_pos.x].monster_types