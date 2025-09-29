# MainMenu.gd
extends Control

@onready var new_game_button: Button = $CenterContainer/MenuItems/NewGameButton
@onready var load_game_button: Button = $CenterContainer/MenuItems/LoadGameButton
@onready var options_button: Button = $CenterContainer/MenuItems/OptionsButton
@onready var quit_button: Button = $CenterContainer/MenuItems/QuitButton

func _ready():
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	new_game_button.grab_focus()
	
	set_process_unhandled_input(true)


	# set up world map data for the first time


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_new_game_pressed():
	# Fade out before transitioning
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.8)
	await get_tree().create_timer(0.5).timeout
	# get_tree().change_scene_to_file("res://main_node.tscn")
	
	get_tree().change_scene_to_file(DirectoryPaths.new_game_window_scene)

func _on_load_game_pressed():
	pass
	# TODO: implement save loading logic
	# SaveManager.load_latest_save() or something

	# check if there is a save file
	if not FileAccess.file_exists(SavePaths.player_data_json):
		print("No save file found, start a new game")
		return

	# load in player data
	var player_json = FileAccess.open(SavePaths.player_data_json, FileAccess.READ)
	var player_data: Dictionary = JSON.parse_string(player_json.get_as_text())
	player_json.close()
	PlayerFactory.make_base_player()
	SaveFuncs.load_player_data(player_data)

	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(DirectoryPaths.main_node_scene)

func _on_options_pressed():
	pass
	# not yet implemented
	# var options_menu = preload("res://ui/options_menu.tscn").instantiate()
	# add_child(options_menu)

func _on_quit_pressed():
	get_tree().quit()