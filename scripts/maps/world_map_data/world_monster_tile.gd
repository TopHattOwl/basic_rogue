class_name WorldMonsterTile
extends Resource

@export var has_dungeon: bool
@export var dungeon_pos: Vector2i
@export var world_map_pos: Vector2i

@export var dungeon: Dungeon = null

func _init(_world_pos: Vector2i = Vector2i.ZERO) -> void:
	has_dungeon = false # filled in when generating world tile
	world_map_pos = _world_pos


func enter_dungeon() -> void:
	if has_dungeon:
		dungeon.enter_dungeon()


## called when generating the dungeons
func add_dungeon_tile(_dungeon: Dungeon) -> void:
	has_dungeon = true
	dungeon = _dungeon
