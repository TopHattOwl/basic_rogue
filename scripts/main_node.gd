extends Node2D

# --- INPUT ---
const INPUT_DIRECTIONS = GameData.INPUT_DIRECTIONS

func _ready():

	# passing main node to game data
	GameData.main_node = self

	MapFunction.load_premade_map(DirectoryPaths.first_outpost)
	EntitySystems.initialize_systems(self)

	# entity system manager initialization
	EntitySystems.entity_spawner.spawn_player(Vector2i(5, 5))

	SaveFuncs.save_player_data(GameData.player)

	EntitySystems.entity_spawner.spawn_monster(Vector2i(8, 5), GameData.MONSTERS1.GIANT_WORM)


	MapFunction.initialize_astar_grid()

	print(MapFunction.chebyshev_distance(get_player_pos(), ComponentRegistry.get_component(GameData.all_hostile_actors[0], GameData.ComponentKeys.POSITION).grid_pos))

	# print("entity map worm", GameData.actors_map[5][6])

	# print(GameData.all_actors)



func _process(_delta):

	if get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn:
		handle_inputs()
	pass



func get_player_comp(comp_key: int) -> Node:
	return ComponentRegistry.get_player_comp(comp_key)

func get_player_pos() -> Vector2i:
	return ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos


# --- INPUT ---

func handle_inputs():

	for action in GameData.INPUT_DIRECTIONS:
		if Input.is_action_just_pressed(action):
			var dir = GameData.INPUT_DIRECTIONS[action]
			var new_grid = get_player_pos() + dir

			# moves player
			# if player moved player's turn is false and it's enemies' turn
			if EntitySystems.movement_system.process_movement(GameData.player, new_grid):
				ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
				handle_hostile_turn()
			break

		if Input.is_action_just_pressed("go_down") and GameData.terrain_map[get_player_pos().y][get_player_pos().x]["tags"].has(GameData.TILE_TAGS.STAIR):
			print("you go down")


func handle_hostile_turn():

	var player_pos = get_player_pos()

	for enemy in GameData.all_hostile_actors:
		var ai = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.AI_BEHAVIOR)
		var enemy_pos = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.POSITION).grid_pos
		print("asd")
		if ai.is_in_range(player_pos, enemy_pos):
			print("ai is in range")
			var target_pos = ai.get_next_position(enemy_pos, player_pos)
			EntitySystems.movement_system.process_movement(enemy, target_pos)

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true
