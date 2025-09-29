extends Node

# --- Game Saves ---

func save_game() -> void:
	save_player_data()

	save_world_map_data()

func load_game() -> void:
	var player_json = FileAccess.open(SavePaths.player_data_json, FileAccess.READ)
	var player_data: Dictionary = JSON.parse_string(player_json.get_as_text())
	player_json.close()
	PlayerFactory.make_base_player()
	load_player_data(player_data)

	load_world_map_data()

func save_player_data(_player_node: Node2D = null):
	SavePlayer.save_player_data(GameData.player)


func load_player_data(data: Dictionary):
	LoadPlayer.load_player_data(data)

# 		--- World Map Data ---
func save_world_map_data() -> void:
	# saves stuff that are simple variables
	SaveWorldMap.save_biome_type_data()
	SaveWorldMap.save_world_map_savagery()
	SaveWorldMap.save_world_map_civilization()

	# saves custom classes
	SaveWorldMap.save_world_maps()

func load_world_map_data() -> void:
	LoadWorldMap.load_biome_type_data()
	LoadWorldMap.load_world_map_savagery()
	LoadWorldMap.load_world_map_civilization()


	LoadWorldMap.load_world_maps()

# --- BASE DATA ---

func save_base_world_map_data():
	# saves stuff that are simple variables
	SaveWorldMap.save_base_biome_type_data()
	SaveWorldMap.save_base_world_map_savagery()
	SaveWorldMap.save_base_world_map_civilization()

	# saves custom classes
	SaveWorldMap.save_base_world_maps()

func load_base_world_map_data():
	# loads stuff that are simple variables
	LoadWorldMap.load_base_biome_type_data()
	LoadWorldMap.load_base_world_map_savagery()
	LoadWorldMap.load_base_world_map_civilization()

	# loads custom classes
	LoadWorldMap.load_base_world_maps()


## loads `data` into player [br] 
func load_player_base(data: Dictionary) -> void:
	if not GameData.player:
		return

	LoadPlayer.load_player_base(data)
