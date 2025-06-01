extends Node2D
# --- INPUT ---
const INPUT_DIRECTIONS = GameData.INPUT_DIRECTIONS
@export var input_manager: Node = null


# finish:
	# finish dungeon class and dungeon level class for everything, not just field

# IDEAS:
	# foraging map (like terrain map, 2d array) for placing foraging objects for player to forage for potions, food and stuff
		# foraging vision -> based on perception and knowlege of plants (notice plants you know better)
		# foraging mode -> regular vision decreeses but foraging vision increases
		# add forage generation in Biome classes 

	# IMPORTANT: FOV how to
		# add TileMapLayer node to player node
		# in it's process function get player pos
		# variables: in vision tiles, expored_map (2d array, value is 1 if expored, 0 if not explored)
		# according to terrain_map transparency and player's vision range, map out what player sees, update explored map and in vision tiles
		# tilemap layer setcell:
			# none on tiles player actively sees
			# explored but not in vision tile: 50% transparency background map
			# not explored, not in vision tile: background tile full transparency

	# finish biome integration to class objects

# TODO:
	# stance_bar.gd: check for weapon and armor type requirement -> only show stances that can be activated
	# add camera2d to targeter, make it active when looking
	# generate seed in WorldMap object using the world seed in GameData
	# add perception attributes (find all references, some are string refereces, like "strenght" when saving and loading player data)
	# Stamina and State componenet not finished
	# in input_manager -> look input 
		# get all terrain data and actor data at look target grid, get actor's sprite for displye, somhow get tile map's tile for display
	# player_ui.gd make look ui array cycleable when looking at tile with more stuff
	# in world_map_data.gd add world_map_identity array, figure out what to put there, name, quests, notes, etc also add it to map generation
	# make thiner road tile for smaller roads
	# make world map save and load smaller (for loop tru each DirectoryPaths.world_save_file)
	# IMPORTANT ui_func.gd -> set_look_ui_target_array() TODO: loop tru terrain_data.tags and add all terrains
func _ready():

	# passing main node to game data
	GameData.main_node = self

	# GameTime.initialize()
	# UiFunc.initialize()

	# MapFunction.load_premade_map(DirectoryPaths.first_outpost)

	EntitySpawner.spawn_player()

	SaveFuncs.save_player_data(GameData.player)

	# SaveFuncs.save_player_data(GameData.player)

	UiFunc.log_message("You arrive in ******")

	# test stances
	GameData.player.StanceComp.add_stance(load("res://resources/combat_stuff/stances/test.tres"))
	GameData.player.StanceComp.add_stance(load("res://resources/combat_stuff/stances/test2.tres"))
	# GameData.player.StanceComp.enter_stance(GameData.player.StanceComp.known_stances[0])

	# test weapon
	var test_weapon = load("res://resources/items/item_instances/weapons/test_weapon.tres")
	GameData.player.EquipmentComp.equip_main_hand(test_weapon)

	GameData.player.add_child(load("res://scenes/ui/damage_text.tscn").instantiate())


func _process(_delta):
# input handler, gets input passed to it and depending on what input is pressed it calls different functions
	if GameData.player.PlayerComp.is_players_turn:

		input_manager.handle_input()


func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
