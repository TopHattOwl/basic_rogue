class_name FieldDungeon
extends Resource

@export var levels: Array = []
@export var boss_id: int 
@export var monster_types: Array
@export var world_map_pos: Vector2i

var rng = RandomNumberGenerator.new()

func make_dungeon(grid_pos: Vector2i) -> void:
    world_map_pos = grid_pos
    rng.seed = WorldMapData.world_map2.map_data[grid_pos.y][grid_pos.x].generated_seed

    monster_types = WorldMapData.world_monster_map.map_data[grid_pos.y][grid_pos.x].monster_types
    var monster_tier = WorldMapData.world_monster_map.map_data[grid_pos.y][grid_pos.x].monster_tier

    var dungeon_levels = rng.randi_range(1, 4)

    for level in dungeon_levels:
        levels.append(DungeonLevel.new())
        levels[level].generate_dugeon_level(level, grid_pos, monster_types, monster_tier)