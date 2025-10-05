class_name WorldMonsterTile
extends Resource

var has_dungeon: bool
var dungeon_pos: Vector2i # dungeon are several tiles big, top left position is dungeon pos
var world_map_pos: Vector2i

var dungeon: Dungeon = null

func _init(_world_pos: Vector2i = Vector2i.ZERO) -> void:
	has_dungeon = false # filled in when generating world tile
	world_map_pos = _world_pos

# called when entering not explored map so it gets generated
func add_dungeon_tile(_dungeon: Dungeon) -> void:
	has_dungeon = true
	dungeon = _dungeon