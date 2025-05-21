extends Node2D


# --- INPUT ---
const INPUT_DIRECTIONS = GameData.INPUT_DIRECTIONS
@export var input_manager: Node = null


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
	# generate seed in WorldMap object using the world seed in GameData
	# IMPORTANT: get rid of old world_map_data, world_map_monster_data in world_map_data.gd, migrated everything to objects
		# but have to finish map generaton first -> each biome has own generation function, WorldMonsterMap has own monster setup function (spawn pos and dungeon setup)
	# add perception attributes (find all references, some are string refereces, like "strenght" when saving and loading player data)
	# Stamina and State componenet not finished
	# IMPORTANT: make giant worm spawn the same way mask does (variables set in own ready script)
	# IMPORTANT: WorldMapData TODO  if explored world map tile in map transition and exit world map, load that data ininstead, not generate
	# load player into the correct world_map tile
	# remove actor nodes when trasitioning maps and entering and exiting world map
	# fix is_action_pressed timer to work properly with everything (right now, using is_action_just_pressed, so cant hold down button)
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

	MapFunction.load_premade_map(DirectoryPaths.first_outpost)

	SaveFuncs.save_player_data(GameData.player)

	EntitySystems.entity_spawner.spawn_item(Vector2i(6,6), GameData.ALL_ITEMS.STEEL_LONGSWORD)

	# test weapon equip and save after
	get_player_comp(GameData.ComponentKeys.EQUIPMENT).equip_weapon(GameData.all_items[0])

	# SaveFuncs.save_player_data(GameData.player)

	UiFunc.log_message("You arrive in ******")

	# WorldMapData.biome_map.map_data[4][42].generate_map()


func _process(_delta):
# input handle autoload, gets input passed to it and depending on what input is pressed it calls different functions
	if get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn:

		input_manager.handle_input()


func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos
