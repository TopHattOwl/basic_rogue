extends Node


var monsters1: Dictionary = {}


func _ready():
	load_all_data()


func load_all_data():
	cache_monsters()


func cache_monsters():
	cache_monsters1()
	chache_monsters2()


func cache_monsters1():
	# clear data
	monsters1.clear()

	for monster_key in DirectoryPaths.monsters1:
		print(DirectoryPaths.monsters1[monster_key])
		monsters1[monster_key] = load_monsters1_from_json(monster_key)

func chache_monsters2():
	pass


func load_monsters1_from_json(monster_key: int) -> Dictionary:

	var file_path = DirectoryPaths.monsters1[monster_key]
   # Validate file existence
	if !FileAccess.file_exists(file_path):
		push_error("Monster data missing: %s" % file_path)
		return {}

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()

    # validate json structure
	if json == null || typeof(json) != TYPE_DICTIONARY:
		push_error("Invalid monster data: %s" % file_path)
		return {}

	# var required_fields = ["health_component", "ai_behavior_component", "monster_stats_component", "melee_combat_component", "identity_component"]
	return json