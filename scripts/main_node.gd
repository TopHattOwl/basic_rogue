extends Node2D

# --- INPUT ---
const INPUT_DIRECTIONS = GameData.INPUT_DIRECTIONS
@export var input_manager: Node = null

# TODO:
	# load player into the correct world_map tile
	# remove actor nodes when trasitioning maps and entering and exiting world map, right now giant worm is invisible in certain cases
	# fix is_action_pressed timer to work properly with everything (right now, using is_action_just_pressed, so cant hold down button)
	# in input_manager -> look input 
		# get all terrain data and actor data at look target grid, get actor's sprite for displye, somhow get tile map's tile for display
	# in map_functions TODO: use GameData.TilemapLayers dictionary to get all layers
	# player_ui.gd make look ui array cycleable when looking at tile with more stuff
func _ready():

	# passing main node to game data
	GameData.main_node = self

	MapFunction.load_premade_map(DirectoryPaths.first_outpost)

	# entity system manager initialization
	EntitySystems.initialize_systems(self)

	SaveFuncs.save_player_data(GameData.player)


	EntitySystems.entity_spawner.spawn_item(Vector2i(6,6), GameData.ALL_ITEMS.STEEL_LONGSWORD)

	# test weapon equip and save after
	get_player_comp(GameData.ComponentKeys.EQUIPMENT).equip_weapon(GameData.all_items[0])

	# SaveFuncs.save_player_data(GameData.player)

	UiFunc.log_message("You arrive in ******")

func _process(_delta):
# input handle autoload, gets input passed to it and depending on what input is pressed it calls different functions
	if get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn:

		input_manager.handle_input()


func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
