extends Node

var talk_screen_node: Control

func open_talk_screen(target_instance: Node2D) -> void:
	var talk_screen = load(DirectoryPaths.talk_screen_scene).instantiate()
	talk_screen.z_as_relative = false
	talk_screen.z_index = GameData.TALK_SCREEN_Z_INDEX
	talk_screen.name = "TalkScreen"

	talk_screen.set_talk_screen_data(target_instance)

	# add talk screen to scene tree
	UiFunc.player_ui.add_child(talk_screen)
	talk_screen_node = talk_screen

	print("talk screen target: ", target_instance)
	print("talk screen target name: ", target_instance.get_component(GameData.ComponentKeys.IDENTITY).actor_name)

func close_talk_screen() -> void:
	print("closing talk screen")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).restore_input_mode()
	talk_screen_node.queue_free()


## if no talk target, restored input mode [br]
## if one talk target, open talk screen, and set input mode to talk screen (not setting prev input mode, so pressing esc will restore to zoomed in input mode)
## if 2 or more possible targets, stay on direction input and wait for player to pick
func pick_talk_target() -> void:
	print("[TalkManager]picking talk target")

	var npcs_in_range_pos = MapFunction.check_actors_in_radius(ComponentRegistry.get_player_pos(), 1, true, false)

	print("npcs in range: ", npcs_in_range_pos)

	if not npcs_in_range_pos:
		UiFunc.log_message("No one to talk to")
		print("no npc in range to talk to, dummy")
		GameData.player.PlayerComp.restore_input_mode()

	if npcs_in_range_pos.size() == 1:
		GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.TALK_SCREEN
		open_talk_screen(GameData.get_actor(npcs_in_range_pos[0]))


	# if 2 or more npcs in range set player input mode to direction input and let them pick
	else:
		return
