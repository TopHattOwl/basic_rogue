extends Control

@export var stats_container: VBoxContainer
@export var char_sprite: Sprite2D

@export var continue_button: Button

var debug: int = 0


func _ready() -> void:
	debug = GameData.new_game_window_debug
	# load in player base stats
	# now its only one starting char
	var player_base_json = FileAccess.open(SavePaths.player_base_json, FileAccess.READ)
	var player_base: Dictionary = JSON.parse_string(player_base_json.get_as_text())
	player_base_json.close()

	if debug:
		print(" ---- NEW GAME WINDOW ---- ")
		print("base player data:")
		print("____")
		for stat in player_base.keys():
			print(stat, ": ", player_base[stat])
		print("____")

	# making empty player
	PlayerFactory.make_base_player()

	# load player base into player
	SaveFuncs.load_player_base(player_base)

	continue_button.pressed.connect(_on_continue_pressed)


func _on_continue_pressed() -> void:
	if debug:
		print("continue button pressed")
	
	# generate randowm world seed
	var _seed = randi_range(11111111, 99999999)
	# for now fix value
	var fixed_seed = 2840132
	GameData.set_world_seed(fixed_seed)
	
	# save newly made player
	SaveFuncs.save_player_data()

	# add loading screen while generating dungeons
	var loading_screen = load(DirectoryPaths.loading_screen_scene).instantiate()
	loading_screen.z_index = GameData.LOADING_SCREEN_Z_INDEX
	get_tree().root.add_child(loading_screen)
	# generate dungeons
	await DungeonManager.generate_dungeons()
	loading_screen.queue_free()


	SignalBus.new_game_stared.emit()
	get_tree().change_scene_to_file(DirectoryPaths.main_node_scene)
	
	
