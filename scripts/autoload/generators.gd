extends Node

var map_generator = preload(DirectoryPaths.map_generator).new()
var dungeon_generator = preload(DirectoryPaths.dungeon_generator).new()


func generate_random_map(world_map_pos: Vector2i):
    map_generator.generate_random_map(world_map_pos)

func generate_random_dungeon(world_map_pos: Vector2i):
    dungeon_generator.generate_random_dungeon(world_map_pos)