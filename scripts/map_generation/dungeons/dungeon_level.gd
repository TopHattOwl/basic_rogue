class_name DungeonLevel
extends Resource

var level: int # starting from 0
var terrain_map: Array
var stair_up: DungeonStair
var stair_down: DungeonStair

# stair positions example
# 1 1 1 1 1 1 1 1 1
# 1 1 1 1 S S 1 1 1
# 1 1 1 1 0 0 0 0 0

# 1 -> wall
# 0 -> floor
# S -> stair


var world_map_pos: Vector2i


func _init(data: Dictionary = {}) -> void:
    pass

func generate_dugeon_level(_level: int, _world_map_pos: Vector2i) -> DungeonLevel:

    # setting variables
    level = _level
    world_map_pos = _world_map_pos


    print("generating dungeon level: ", level + 1)
    
    print("dungeon: ", self)


    return self
