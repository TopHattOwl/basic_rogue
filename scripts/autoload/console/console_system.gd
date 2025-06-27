extends Node

var commands: Dictionary = {}


func _ready() -> void:

	# helpers
	register_command("help", help_command, "Shows all commands")
	register_command("clear", clear_command, "Clears console output")
	register_command("monster_ids", get_monster_ids, "Returns all monster ids")

	# player commands
	register_command("heal", heal_command, "Heals player by given amount\n\t\theal [amount]")

	# spawn commands
	register_command("spawn_monster", spawn_monster_command, "Spawns a monster with given id at given position\n\t\tspawn_monster [id] [x] [y]")
	register_command("spawn_item", spawn_item_command, "Spawns an item with given id at given position\n\t\tspawn_item [id] [x] [y]")


func register_command(_name: String, _callback: Callable, _description: String = "") -> void:
	commands[_name] = {
		"callback": _callback,
		"description": _description
	}


func execute_command(raw_input: String) -> String:
	var parts = raw_input.split(" ", false)
	if parts.is_empty():
		return "Error: Empty command"


	var command_name = parts[0].to_lower()
	var args = parts.slice(1)

	if not commands.has(command_name):
		return "Error: Unknown command: " + "'" + command_name + "'"
	
	var command = commands[command_name]
	return command.callback.call(args)




# --- HELPER COMMANDS ---
func help_command(_args: PackedStringArray) -> String:
	var output = "Available commands:\n"
	for command in commands:
		output += "- " + command + ": " + commands[command].description + "\n"
	return output

func clear_command(_args: PackedStringArray) -> String:
	return "runnung clear command"

func get_monster_ids(_args: PackedStringArray) -> String:
	var output = "All monster uids:\n"
	for id in GameData.MONSTER_UIDS:
		output += "\t\t"+ GameData.MONSTER_UIDS[id] + ": " + str(id) + "\n"
	return output

# --- PLAYER COMMANDS ---
func heal_command(_args: PackedStringArray) -> String:
	if _args.is_empty():
		return "Error: Missing argument for heal command: amount\n" + "Usage: heal [amount]"

	GameData.player.HealthComp.heal(_args[0].to_int())
	return "healing player by: " + _args[0]


# --- SPAWN COMMANDS ---

func spawn_monster_command(_args: PackedStringArray) -> String:
	var output = ""

	var grid_pos := Vector2i.ZERO
	var monster_uid = GameData.MONSTER_UIDS[int(_args[0])]

	if _args.is_empty():
		return "Error: Missing arguments for spawn_monster command: id, x, y\n" + "Usage: spawn_monster [id] [x] [y]"

	var is_pos_given = _args.size() > 1

	# if no pos given, get random avalible pos
	if not is_pos_given:
		
		var avalible_tiles = MapFunction.get_tiles_in_radius(
			GameData.player.PositionComp.grid_pos,
			# FovManager.player_vision_range,
			5,
			false,
			false,
			"euclidean",
			true,
			true
		)
		if avalible_tiles.is_empty():
			return "Cannot spawn monster, no avalible tiles nearby"

		grid_pos = avalible_tiles[randi() % avalible_tiles.size()]

	# if pos given, check if it is valid
	else:
		grid_pos = Vector2i(_args[1].to_int(), _args[2].to_int())
		if not MapFunction.can_spawn_monster_at_pos(grid_pos):
			return "cannot spawn at: " + "(" +_args[1] + ", " + _args[2] + ")"

	output = "spawning monster: " + monster_uid + " at: " + "(" + str(grid_pos.x) + ", " + str(grid_pos.y) + ")"

	EntitySpawner.spawn_monster(grid_pos, int(_args[0]))

	return output

func spawn_item_command(_args: PackedStringArray) -> String:
	var output = ""
	if _args.is_empty():
		return "Error: Missing arguments for spawn_item command: id, x, y\n" + "Usage: spawn_item [id] [x] [y]"

	return output
