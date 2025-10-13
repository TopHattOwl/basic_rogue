class_name DungeonLevel
extends Resource

var level: int # starting from 0
var terrain_map: Array
var stair_up: DungeonStair
var stair_down: DungeonStair

var rng: RandomNumberGenerator


var world_map_pos: Vector2i


func _init(data: Dictionary = {}) -> void:
	pass


func generate_dugeon_level(_level: int, _world_map_pos: Vector2i) -> void:
	rng = RandomNumberGenerator.new()
	rng.seed = (_level + 1) * (_world_map_pos.x + 1) + (_world_map_pos.y + 1)
	level = _level
	world_map_pos = _world_map_pos

	generate_level_terrain()


## overriden in child classes
func generate_level_terrain() -> void:
	pass