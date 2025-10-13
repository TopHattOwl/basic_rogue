class_name DungeonStair
extends Resource

var is_up: bool
var depth: int
var pos: Vector2i # stair position in the dungeon
var spawn_pos: Vector2i # the position to spawn the player at when coming out of this stair

func _init(data: Dictionary = {}) -> void:
	is_up = data.get("is_up", false)
	depth = data.get("depth", 0)
	pos = data.get("pos", Vector2i.ZERO)
	spawn_pos = data.get("spawn_pos", Vector2i.ZERO)



func use_stair() -> void:

	var dungeon: Dungeon = GameData.current_dungeon_class

	if is_up:
		if depth == 0:
			dungeon.exit_dungeon()
			return
		dungeon.enter_dungeon_level(depth - 1, "up")
		return

	dungeon.enter_dungeon_level(depth + 1)
