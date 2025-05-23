extends Node

const INITIAL_DELAY = 2.5
const REPEAT_DELAY = 0.15
var _input_states := {}

var player_look_pos: Vector2i



# the difference between the look pos and the player pos in grid
var look_diff_from_player: Vector2i = Vector2i.ZERO

func handle_input() -> void:
	match ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode:

		GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT:
			handle_zoomed_in_inputs()
		GameData.INPUT_MODES.WORLD_MAP_MOVEMENT:
			handle_world_map_inputs()
		GameData.INPUT_MODES.LOOK:
			handle_look_inputs()
		GameData.INPUT_MODES.UI_INPUT:
			handle_ui_inputs()


# --- ZOOMED IN INPUTS ---
func handle_zoomed_in_inputs():

	var current_time = Time.get_ticks_msec()

	# general movement
	for action in GameData.INPUT_DIRECTIONS:
		var dir = GameData.INPUT_DIRECTIONS[action]

		if Input.is_action_just_pressed(action):
			# immidiate respone on first press
			_process_movement(dir)

			_input_states[action] = {
				"last_press_time": current_time,
				"in_repeat": false
			}
		elif Input.is_action_pressed(action):
			# handle repeate after initial delay
			print("repeat input")

			var state = _input_states.get(action, {})

			print(state)

			if state:
				var elapsed = current_time - state.last_press_time

				if not state.in_repeat and elapsed > INITIAL_DELAY * 1000:
					_process_movement(dir)
					state.in_repeat = true
					state.last_press_time = current_time
				elif state.in_repeat and elapsed > REPEAT_DELAY * 1000:
					_process_movement(dir)
					state.last_press_time = current_time
		else:
			_input_states.erase(action)
			
			# var new_grid = ComponentRegistry.get_player_pos() + dir

			# timer for using is_action_pressed
			# await get_tree().create_timer(0.2).timeout

			# moves player
			# if player moved player's turn is false and it's enemies' turn
			# if EntitySystems.movement_system.process_movement(GameData.player, new_grid):
			# 	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
			# 	handle_hostile_turn()

	# pick up 
	if Input.is_action_just_pressed("pick_up") and GameData.items_map[ComponentRegistry.get_player_pos().y][ComponentRegistry.get_player_pos().x]:
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
		var pos = ComponentRegistry.get_player_pos()
		EntitySystems.inventory_system.pick_up_item(pos)

		# TODO pickup window

	# enter world map 
	if Input.is_action_just_pressed("open_world_map") and not ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
		MapFunction.enter_world_map()

	if Input.is_action_just_pressed("quit"):
		print("quitting")
		SaveFuncs.save_player_data(GameData.player)
		get_tree().quit()
	
	if Input.is_action_just_pressed("dev_overlay"):
		GameData.player.get_node("DevTools").toggle_dev_overlay()
	
	if Input.is_action_just_pressed("look"):
		toggle_look_mode()


# --- WORLD MAP INPUTS ---
func handle_world_map_inputs():
	for action in GameData.INPUT_DIRECTIONS:
		if Input.is_action_just_pressed(action):
			var dir = GameData.INPUT_DIRECTIONS[action]
			var new_grid = ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos + dir

			if EntitySystems.movement_system.process_world_map_movement(new_grid):
				ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true
			break
		if Input.is_action_just_pressed("open_world_map") and ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
			MapFunction.exit_world_map()
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true


# --- LOOK INPUTS ---
func handle_look_inputs():
	# TODO display look target image
	if Input.is_action_just_pressed("look"):
		toggle_look_mode()

	for action in GameData.INPUT_DIRECTIONS:
		if Input.is_action_just_pressed(action):

			# variable set
			var dir = GameData.INPUT_DIRECTIONS[action]
			look_diff_from_player += dir
			var look_target_grid = ComponentRegistry.get_player_pos() + look_diff_from_player

			# bounds check
			if !MapFunction.is_in_bounds(look_target_grid):
				look_diff_from_player -= dir
				break

			# flipping look ui if needed
			if look_diff_from_player.x > 3 and UiFunc.player_ui.look_ui_side == 1:
				UiFunc.player_ui.flip_look_ui()
			elif look_diff_from_player.x < -3 and UiFunc.player_ui.look_ui_side == -1:
				UiFunc.player_ui.flip_look_ui()

			
			# updating look ui's target array
			UiFunc.set_look_ui_target_array(look_target_grid)
			break

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true


# --- UI INPUTS ---
func handle_ui_inputs():
	pass	


# --- HOSTILES ---
func handle_hostile_turn():
	set_process_input(false)

	var player_pos = ComponentRegistry.get_player_pos()

	for enemy in GameData.all_hostile_actors:
		var ai = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.AI_BEHAVIOR)
		var enemy_pos = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.POSITION).grid_pos

		if ai.is_in_range(player_pos, enemy_pos):

			var target_pos = ai.get_next_position(enemy_pos, player_pos)
			EntitySystems.movement_system.process_movement(enemy, target_pos)

	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true

	set_process_input(true)

# --- INPUT TRANSITIONS ---

func toggle_look_mode() -> void:
	if ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode == GameData.INPUT_MODES.LOOK:
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode = GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT
		UiFunc.toggle_look_ui()
	else:
		ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode = GameData.INPUT_MODES.LOOK

		# reset look diff and set look ui texture
		look_diff_from_player = Vector2i(0, 0)
		UiFunc.set_look_ui_target_array(ComponentRegistry.get_player_pos())
		
		# toggle look ui visibility
		UiFunc.toggle_look_ui()

func toggle_world_map_look_mode() -> void:
	pass



# --- UTILS ---

func _process_movement(dir: Vector2i) -> void:
	var new_grid = ComponentRegistry.get_player_pos() + dir
	if EntitySystems.movement_system.process_movement(GameData.player, new_grid):
		_end_player_turn()

	

func _end_player_turn() -> void:
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
	handle_hostile_turn()
	_input_states.clear()
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true