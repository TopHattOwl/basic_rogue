class_name WorldMonsterMap

@export var map_data: Array[Array]

func _init() -> void:

    map_data = []

    for y in range(GameData.WORLD_MAP_SIZE.y):
        map_data.append([])
        for x in range(GameData.WORLD_MAP_SIZE.x):
            map_data[y].append(null)
