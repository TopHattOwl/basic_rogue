class_name PlayerComponent
extends Node

# stores actions in order
var action_queue: Array = []
# {type: "move", target: Vector2i} or {"type": "pass"}


var is_queue_active: bool = false


var is_in_dungeon: bool = false
var is_players_turn: bool = true
var is_in_world_map: bool = false


var world_map_pos: Vector2i = Vector2i.ZERO:
	set(value):
		var prev = world_map_pos
		world_map_pos = value
		SignalBus.world_map_pos_changed.emit(world_map_pos, prev)


var is_dead: bool = false
var input_mode: int = 0 # from enum INPUT_MODES
var prev_input_mode: int = 0


func set_prev_input_mode() -> void:
	prev_input_mode = input_mode

func restore_input_mode() -> void:
	input_mode = prev_input_mode



# TODO: finish action queueing
# QUEUEING

# func add_to_queue(action: Dictionary) -> void:
# 	action_queue.append(action)
# 	is_queue_active = true


# func execute_next_action() -> bool:
# 	if action_queue.size() == 0:
# 		return false

# 	var action = action_queue.pop_front()

# 	match action.type:
# 		"move":
# 			var dir = action.target - ComponentRegistry.get_player_pos()
# 			MovementSystem.process_movement(GameData.player, dir)
# 		"pass":
# 			pass

# 	return action_queue.size() > 0
