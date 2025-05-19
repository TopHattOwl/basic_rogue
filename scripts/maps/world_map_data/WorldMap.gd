class_name WorldMap
extends Resource


@export var map_data: Array[Array]


func _init() -> void:

    map_data = []

    for y in range(GameData.WORLD_MAP_SIZE.y):
        map_data.append([])
        for x in range(GameData.WORLD_MAP_SIZE.x):
            map_data[y].append(WorldMapTile.new(Vector2i(x, y)))


func add_premade_map(path: String, pos: Vector2i) -> void:
    map_data[pos.y][pos.x].add_premade_map(path)

func reset_tile(pos: Vector2i) -> void:
    map_data[pos.y][pos.x] = WorldMapTile.new(pos)


func is_tile_walkable(pos: Vector2i) -> bool:
    return map_data[pos.y][pos.x].walkable

func is_in_bounds(pos: Vector2i) -> bool:
    return pos.x >= 0 and pos.x < GameData.WORLD_MAP_SIZE.x and pos.y >= 0 and pos.y < GameData.WORLD_MAP_SIZE.y

