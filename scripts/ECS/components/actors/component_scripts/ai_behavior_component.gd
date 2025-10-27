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


func execute_ai_action() -> Action:
	var player_pos: Vector2i = ComponentRegistry.get_player_pos()
	var _entity: Node2D = get_parent().get_parent()

	var self_pos_comp: PositionComponent = ComponentRegistry.get_component(get_parent().get_parent(), GameData.ComponentKeys.POSITION)
	
	if is_in_range(player_pos, self_pos_comp.grid_pos):
		var target_pos = get_next_position(self_pos_comp.grid_pos, player_pos)
		var _action: Action = MovementSystem.process_monster_movement(get_parent().get_parent(), target_pos)
	
		return _action

	
	return ActionFactory.make_action({"entity": _entity})

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
	current_path = MapFunction.astar_get_path(current_pos, target_pos)
	
	if current_path.size() == 0:
		return current_pos
	if current_path.size() == 1:
		return current_pos
	# Return next step or current position if no path
	return current_path[1]

func is_in_range(ai_pos: Vector2i, target_pos: Vector2i) -> bool:

	if MapFunction.chebyshev_distance(ai_pos, target_pos) <= vision_range:
		return true
	return false
