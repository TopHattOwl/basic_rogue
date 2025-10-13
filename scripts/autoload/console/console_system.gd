extends Node

var commands: Dictionary = {}


func _ready() -> void:

	# helpers
	register_command("help", help_command, "Shows all commands")
	register_command("clear", clear_command, "Clears console output")
	register_command("monster_ids", get_monster_ids, "Returns all monster ids: [uid: id]")
	register_command("npc_ids", get_npc_ids, "Returns all NPC ids: [uid: id]")
	register_command("skill_ids", get_skill_ids, "Returns all skill ids")

	# player commands
	register_command("heal", heal_command, "Heals player by given amount\n\t\theal (amount)")
	register_command("add_skill_exp", add_skill_exp_command, "Adds given amount of skill experience to player\n\t\tadd_skill_exp [skill_id] [amount]")
	register_command("ghost", ghost_command, "Toggles ghost mode for player\n\tIn ghost mode player can go trough walls")

	# spawn commands
	register_command("spawn_monster", spawn_monster_command, "Spawns a monster with given id at given position\n\t\tspawn_monster (id/uid) (x) (y)")
	register_command("spawn_npc", spawn_npc_command, "Spawns an npc with given id at given position\n\t\tspawn_npc (id/uid) (x) (y)")
	register_command("spawn_item", spawn_item_command, "NOT IMPLEMENTED\nSpawns an item with given id at given position\n\t\tspawn_item [id] [x] [y]")

	# time commans
	register_command("pass_day", pass_day_command, "Skips to the first turn on the next day")


	


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
	var output = "-----HELP-----\nAvailable commands:\n"
	for command in commands:
		output += "- " + "[color=yellow]" + command + "[/color]" + ": " + commands[command].description + "\n"
	
	output += "-------\nAnnotation: command [arguments]\n if arguments is inside [] it is required, if inside () it is optional\n"
	return output

func clear_command(_args: PackedStringArray) -> String:
	return "runnung clear command"

func get_monster_ids(_args: PackedStringArray) -> String:
	var output = "All monster ids:\n"
	for id in GameData.MONSTER_UIDS:
		output += "\t\t"+ GameData.MONSTER_UIDS[id] + ": " + str(id) + "\n"
	return output

func get_npc_ids(_args: PackedStringArray) -> String:
	var output = "All npc ids:\n"
	for id in GameData.NPC_UIDS:
		output += "\t\t"+ GameData.NPC_UIDS[id] + ": " + str(id) + "\n"
	return output

func get_skill_ids(_args: PackedStringArray) -> String:
	var output = "All skill ids:\n"

	for skill_id in GameData.SKILL_NAMES:
		output += "\t\t"+ GameData.SKILL_NAMES[skill_id] + ": " + str(skill_id) + "\n"
	
	return output

# --- PLAYER COMMANDS ---
func heal_command(_args: PackedStringArray) -> String:
	var heal_amount = _args[0].to_int() if not _args.is_empty() else 0
	# if _args.is_empty():
	# 	return "Error: Missing argument for heal command: amount\n" + "Usage: heal [amount]"

	if heal_amount:
		GameData.player.HealthComp.heal(heal_amount)
		return "healing player by: " + heal_amount
	else:
		GameData.player.HealthComp.heal(99990)
		return "healing player to full health"
	

func add_skill_exp_command(_args: PackedStringArray) -> String:

	if _args.is_empty():
		return "Error: Missing arguments for add_skill_exp command: skill_id, amount\n" + "Usage: add_skill_exp [skill_id] [amount]"

	var skill_id = _args[0].to_int()

	var exp_amount = _args[1].to_int() if _args.size() > 1 else GameData.player.SkillsComp.skills[skill_id].exp_for_next_level
	var skill_name = GameData.SKILL_NAMES[skill_id] 
	var output = "Adding " + str(exp_amount) + " exp to skill: " + skill_name

	GameData.player.SkillsComp.add_exp(skill_id, exp_amount)
	
	return output


func ghost_command(_args: PackedStringArray) -> String:
	if GameData.player.get_node("Components/GhostComponent"):
		GameData.player.get_node("Components/GhostComponent").queue_free()
		return "Turning ghost mode off"
	else:
		var ghost_comp = GhostComponent.new()
		GameData.player.get_node("Components").add_child(ghost_comp)
		return "Turning ghost mode on"

# --- SPAWN COMMANDS ---

func spawn_monster_command(_args: PackedStringArray) -> String:
	var output = ""
	var monster_id = -1
	var monster_uid = ""


	if _args.is_empty():
		monster_id = randi() % GameData.MONSTERS_ALL.size()
	else:
		var arg = _args[0]

		# check if _args[0] is id or uid
		if arg.is_valid_int():
			# NUMERIC ID CASE
			monster_id = arg.to_int()
			monster_uid = GameData.MONSTER_UIDS[monster_id]
			if monster_id < 0 or monster_id >= GameData.MONSTERS_ALL.size():
				return "Error: Invalid monster id: " + arg 

		else:
			# UID CASE
			if GameData.MONSTER_UIDS.values().has(arg):

				for key in GameData.MONSTER_UIDS:
					if GameData.MONSTER_UIDS[key] == arg:
						monster_id = key
						monster_uid = arg
						break
			else:
				return "Error: Invalid monster uid: " + arg


	var grid_pos := Vector2i.ZERO

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

	EntitySpawner.spawn_monster(grid_pos, monster_id)

	return output

func spawn_npc_command(_args: PackedStringArray) -> String:
	var output = ""
	var npc_id = -1
	var npc_uid = ""


	if _args.is_empty():
		npc_id = randi() % GameData.NPCS_ALL.size()
	else:
		var arg = _args[0]

		# check if _args[0] is id or uid
		if arg.is_valid_int():
			# NUMERIC ID CASE
			npc_id = arg.to_int()
			npc_uid = GameData.NPC_UIDS[npc_id]
			if npc_id < 0 or npc_id >= GameData.NPCS_ALL.size():
				return "Error: Invalid npc id: " + arg 

		else:
			# UID CASE
			if GameData.NPC_UIDS.values().has(arg):

				for key in GameData.NPC_UIDS:
					if GameData.NPC_UIDS[key] == arg:
						npc_id = key
						npc_uid = arg
						break
			else:
				return "Error: Invalid npc uid: " + arg


	var grid_pos := Vector2i.ZERO

	var is_pos_given = _args.size() > 1

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
			return "Cannot spawn npc, no avalible tiles nearby"

		grid_pos = avalible_tiles[randi() % avalible_tiles.size()]

	# if pos given, check if it is valid
	else:
		grid_pos = Vector2i(_args[1].to_int(), _args[2].to_int())
		if not MapFunction.can_spawn_monster_at_pos(grid_pos):
			return "cannot spawn at: " + "(" +_args[1] + ", " + _args[2] + ")"

	output = "spawning npc: " + npc_uid + " at: " + "(" + str(grid_pos.x) + ", " + str(grid_pos.y) + ")"

	EntitySpawner.spawn_npc(grid_pos, npc_id)

	return output

func spawn_item_command(_args: PackedStringArray) -> String:
	var output = ""
	if _args.is_empty():
		return "Error: Missing arguments for spawn_item command: id, x, y\n" + "Usage: spawn_item [id] [x] [y]"

	return output



func pass_day_command(_args: PackedStringArray = []) -> String:
	GameTime.pass_day()
	return "passing day"