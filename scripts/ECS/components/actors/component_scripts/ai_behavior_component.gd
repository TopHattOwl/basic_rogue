class_name AiBehaviorComponent
extends Node

var type: String
var is_hostile: bool = false
var vision_range: int
var current_path: PackedVector2Array = []


func initialize(d: Dictionary) -> void:
	type = d.get("type", "chase")
	is_hostile = d.get("is_hostile", false)
	vision_range = d.get("vision_range", 8)

func set_ai_type(ai_type: String):
	type = ai_type 

func get_next_position(current_pos: Vector2i, target_pos: Vector2i) -> Vector2i:
	if type == "chase":
		return get_chase_position(current_pos, target_pos)
	return current_pos

func get_chase_position(current_pos: Vector2i, target_pos: Vector2i) -> Vector2i:
	# Chebyshev distance check
	if MapFunction.chebyshev_distance(current_pos, target_pos) > vision_range:
		current_path = []
		return current_pos
	
	# Get A* path
	current_path = MapFunction.get_path_astar(current_pos, target_pos)
	
	# Return next step or current position if no path
	return current_path[1] if current_path.size() > 1 else current_pos

func is_in_range(ai_pos: Vector2i, target_pos: Vector2i) -> bool:

	if MapFunction.chebyshev_distance(ai_pos, target_pos) <= vision_range:
		return true
	return false
