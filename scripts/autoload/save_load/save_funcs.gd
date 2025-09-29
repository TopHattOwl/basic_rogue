extends Node


func save_player_data(_player_node: Node2D = null):
	var player_node = GameData.player

	SavePlayer.save_player_data(player_node)


func load_player_data(data: Dictionary):
	LoadPlayer.load_player_data(data)



# --- Base Data ---

func save_base_world_map_data():
	# saves stuff that are simple variables
	SaveWorldMap.save_base_biome_type_data()
	SaveWorldMap.save_base_world_map_savagery()
	SaveWorldMap.save_base_world_map_civilization()

	# saves custom classes
	SaveWorldMap.save_base_world_maps()

func load_base_world_map_data():
	# loads stuff that are simple variables
	LoadWorldMap.load_biome_type_data()
	LoadWorldMap.load_world_map_savagery()
	LoadWorldMap.load_world_map_civilization()

	# loads custom classes
	LoadWorldMap.load_world_maps()


## loads `data` into player [br] 
func load_player_base(data: Dictionary) -> void:
	if not GameData.player:
		return

	LoadPlayer.load_player_base(data)