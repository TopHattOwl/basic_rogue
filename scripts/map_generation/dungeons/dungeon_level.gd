class_name DungeonLevel
extends Node

# - **level**: int, the level of the dungeon (starting from 0)
# - **Map size**: Vector2i of the map size
# - **Terrain map**: terrain map for the Dungeon node to draw map
# - **Stair down pos**:: Vector2i, position of entrance leading further
# - **Stair up pos**: Vector2i, position of entrance leading back

@export var level: int # starting from 0
@export var map_size: Vector2i
@export var terrain_map: Array
@export var stair_down_pos: Vector2i
@export var stair_up_pos: Vector2i

# stair positions example
# 1 1 1 1 1 1 1 1 1
# 1 1 1 1 S S 1 1 1
# 1 1 1 1 0 0 0 0 0

# 1 -> wall
# 0 -> floor
# S -> stair

# filled when generating, array of dictionaries
@export var spawn_points: Array 
# var spawn_point_template = {
#     "pos": Vector2i,
#     "monster_key": int 
# }


var world_map_pos: Vector2i

var monster_types: Array
var monster_tier: int

var biome_type: int

func generate_dugeon_level(_level: int, _world_map_pos: Vector2i, _monster_types: Array, _monster_tier: int) -> DungeonLevel:

    # setting variables
    level = _level
    world_map_pos = _world_map_pos
    monster_types = _monster_types
    monster_tier = _monster_tier


    print("generating dungeon level: ", level + 1)
    
    print("dungeon: ", self)

    map_size = calc_map_size()

    print("dungeon level size: ", map_size)


    

    return self


# --- Utils ---

func calc_map_size() -> Vector2i:

    var _map_size := Vector2i.ZERO

    var x = GameData.MAP_SIZE.x / 3 + WorldMapData.world_map_savagery[world_map_pos.x][world_map_pos.y]
    var y = GameData.MAP_SIZE.y / 3 + WorldMapData.world_map_savagery[world_map_pos.y][world_map_pos.y]

    _map_size = Vector2i(x, y)

    return _map_size
