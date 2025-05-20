class_name WorldMapTile
extends Resource

@export var is_premade: bool
@export var map_path: String
@export var generated_seed: int
@export var explored: bool
@export var walkable: bool
@export var grid_pos: Vector2i

func _init(_pos: Vector2i = Vector2i.ZERO) -> void:
	pass

func setup(pos: Vector2i) -> void:
	is_premade = false
	map_path = ""
	generated_seed = randi_range(111111, 999999)
	explored = false
	walkable = true
	grid_pos = pos

func add_premade_map(path: String) -> void:
	is_premade = true
	map_path = path
	generated_seed = 0