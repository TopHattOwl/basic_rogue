class_name Dungeon
extends Node

var id: int
var levels: Array[DungeonLevel] = []
var world_map_pos: Vector2i

var rng = RandomNumberGenerator.new()


func _init(data: Dictionary = {}) -> void:
	id = data.get("id", -1)
	rng.seed = data.get("rng_seed", 5)
	world_map_pos = data.get("world_map_pos", Vector2i.ZERO)


	# make levels here maybe
