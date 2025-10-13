class_name Dungeon
extends Resource

var id: int
var levels: Array[DungeonLevel] = []
var world_map_pos: Vector2i

var rng = RandomNumberGenerator.new()


func _init(data: Dictionary = {}) -> void:
	id = data.get("id", -1)
	rng.seed = data.get("rng_seed", 5)
	world_map_pos = data.get("world_map_pos", Vector2i.ZERO)

	if not check_data(data):
		push_error("dungeon data is missing required fields\ndata: ", data)
		return


func enter_dungeon() -> void:
	print("entering dungeon:\n\tid: {0}\n\tworld map pos: {1}".format([id, world_map_pos]))

# --- Checks ---

func check_data(data: Dictionary) -> bool:
	return check_id(data) and check_world_map_pos(data) and check_rng_seed(data)

func check_id(data: Dictionary) -> bool:
	return data.has("id")

func check_world_map_pos(data: Dictionary) -> bool:
	return data.has("world_map_pos")

func check_rng_seed(data: Dictionary) -> bool:
	return data.has("rng_seed")