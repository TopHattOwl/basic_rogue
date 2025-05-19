class_name BiomeMap
extends Resource

## looolll
@export var map_data: Array[Array]

func _init() -> void:

    map_data.resize(GameData.WORLD_MAP_SIZE.y)
    for y in range(GameData.WORLD_MAP_SIZE.y):
        map_data[y] = []
        map_data[y].resize(GameData.WORLD_MAP_SIZE.x)

func save_biome_map() -> void:
    ResourceSaver.save(self, GameData.biome_map_save)


func load_biome_map() -> void:
    if ResourceLoader.exists(GameData.biome_map_save):
        var loaded_data = ResourceLoader.load(
            GameData.biome_map_save,
            "",
            ResourceLoader.CACHE_MODE_IGNORE # bypass chache for fresh data
        )
        map_data = loaded_data.map_data