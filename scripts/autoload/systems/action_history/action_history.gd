extends Node
## keeps track of player's last actions

enum ACTION {ENTER_DUNGEON, EXIT_DUNGEON, CHANGE_WORLD_POS}

var ACTIONS_LIMIT = 25

var action_history: Array = []

var debug: int

func _ready() -> void:
	debug = GameData.action_history_debug
	SignalBus.world_map_pos_changed.connect(_on_world_map_pos_changed)
	SignalBus.entered_dungeon.connect(_on_entered_dungeon)
	SignalBus.exited_dungeon.connect(_on_exited_dungeon)


func _on_world_map_pos_changed(to: Vector2i, from: Vector2i) -> void:
	add_action(ACTION.CHANGE_WORLD_POS, {"from": from, "to": to})

func _on_entered_dungeon(data: Dictionary) -> void:
	add_action(ACTION.ENTER_DUNGEON, data)

func _on_exited_dungeon(data: Dictionary) -> void:
	add_action(ACTION.EXIT_DUNGEON, data)
	

## Adds action to 
func add_action(action_to_add: ACTION, data: Dictionary) -> void:
	var _action = data
	_action["action"] = action_to_add
	_action["action_name"] = ACTION.keys()[action_to_add]
	_action["time"] = GameTime.get_date()


	action_history.push_front(_action)

	# circular buffer
	if action_history.size() > ACTIONS_LIMIT:
		action_history.pop_back()

	if debug:
		print("[ActionHistory] Added action: ", ACTION.keys()[action_to_add], " | Total actions: ", action_history.size())

	

# --- Getters ---

func get_most_recent_action() -> Dictionary:
	if action_history.is_empty():
		return {}
	return action_history[0]

## Gets action at specific index (0 = most recent)
func get_action_at(index: int) -> Dictionary:
	if index < 0 or index >= action_history.size():
		return {}
	return action_history[index]


## Gets all actions of a specific type
func get_actions_by_type(action_type: ACTION) -> Array:
	var filtered: Array = []
	for action in action_history:
		if action.get("action") == action_type:
			filtered.append(action)
	return filtered

# --- Bools ---

## Checks if player has been in a dungeon for a specific amount of turns [br]
## if no turns specified, defaults to 100 turns
func been_in_dungeon(turns: int = 100) -> bool:

	var _action: Dictionary = {}

	# find most recent dungeon entry
	for action in action_history:
		if action.action == ACTION.ENTER_DUNGEON or action.action == ACTION.EXIT_DUNGEON:
			_action = action
			break

	if _action.is_empty():
		return false

	var date_difference = GameTime.get_date_difference(_action.time)

	if debug:
		print("[action_history] date difference: ", date_difference)

	if date_difference > turns:
		return false

	return true



## Clears all action history
func clear_history() -> void:
	action_history.clear()
	if debug:
		print("[ActionHistory] History cleared")
