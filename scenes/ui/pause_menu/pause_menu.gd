extends Control


@onready var save_game_button: Button = $CenterContainer/MenuItems/SaveGameButton
@onready var options_button: Button = $CenterContainer/MenuItems/OptionsButton
@onready var quit_button: Button = $CenterContainer/MenuItems/QuitButton


func _ready():
	save_game_button.pressed.connect(_on_save_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	save_game_button.grab_focus()
	
	set_process_unhandled_input(true)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		GameData.player.PlayerComp.restore_input_mode()
		queue_free()


func _on_save_game_pressed():
	var loading_screen = load(DirectoryPaths.loading_screen_scene).instantiate()
	loading_screen.z_index = GameData.LOADING_SCREEN_Z_INDEX
	UiFunc.player_ui.add_child(loading_screen)
	loading_screen._on_loading_label_changed("Saving Game...")
	await  SaveFuncs.save_game()

	loading_screen.queue_free()

func _on_options_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()