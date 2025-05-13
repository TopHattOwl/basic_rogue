extends Node2D

# --- INPUT ---
const INPUT_DIRECTIONS = GameData.INPUT_DIRECTIONS


# TODO:
	# load player into the correct world_map tile
	# remove actor nodes when trasitioning maps and entering and exiting world map, right now giant worm is invisible in certain cases
	# fix is_action_pressed timer to work properly with everything
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

	if get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn:
		if get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
			handle_world_map_inputs()
		else:
			handle_zoomed_in_inputs()



func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos


# --- INPUT ---


func handle_zoomed_in_inputs():

	for action in GameData.INPUT_DIRECTIONS:
		if Input.is_action_just_pressed(action): # if using is_action_pressed holding down the button will work but too fast
			var dir = GameData.INPUT_DIRECTIONS[action]
			var new_grid = get_player_pos() + dir

			# timer for using is_action_pressed
			# await get_tree().create_timer(0.2).timeout

			# moves player
			# if player moved player's turn is false and it's enemies' turn
			if EntitySystems.movement_system.process_movement(GameData.player, new_grid):
				ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
				handle_hostile_turn()
			break

	if Input.is_action_just_pressed("pick_up") and GameData.items_map[get_player_pos().y][get_player_pos().x]:
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
		var pos = get_player_pos()
		EntitySystems.inventory_system.pick_up_item(pos)

		# TODO pickup window

	if Input.is_action_just_pressed("open_world_map") and not get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
		MapFunction.enter_world_map()


	if Input.is_action_just_pressed("quit"):
		print("quitting")
		SaveFuncs.save_player_data(GameData.player)
		get_tree().quit()
	
	if Input.is_action_just_pressed("dev_overlay"):
		GameData.player.get_node("DevTools").toggle_dev_overlay()
		print(WorldMapData.world_map)


func handle_world_map_inputs():
	for action in GameData.INPUT_DIRECTIONS:
		if Input.is_action_just_pressed(action):
			var dir = GameData.INPUT_DIRECTIONS[action]
			var new_grid = get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos + dir

			if EntitySystems.movement_system.process_world_map_movement(new_grid):
				ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true
			break
		if Input.is_action_just_pressed("open_world_map") and get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
			MapFunction.exit_world_map()
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true


func handle_hostile_turn():

	var player_pos = get_player_pos()

	for enemy in GameData.all_hostile_actors:
		var ai = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.AI_BEHAVIOR)
		var enemy_pos = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.POSITION).grid_pos

		if ai.is_in_range(player_pos, enemy_pos):

			var target_pos = ai.get_next_position(enemy_pos, player_pos)
			EntitySystems.movement_system.process_movement(enemy, target_pos)

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true
