# MainMenu.gd
extends Control

@onready var new_game_button: Button = $CenterContainer/MenuItems/NewGameButton
@onready var load_game_button: Button = $CenterContainer/MenuItems/LoadGameButton
@onready var options_button: Button = $CenterContainer/MenuItems/OptionsButton
@onready var quit_button: Button = $CenterContainer/MenuItems/QuitButton

func _ready():
    # Connect signals
    new_game_button.pressed.connect(_on_new_game_pressed)
    load_game_button.pressed.connect(_on_load_game_pressed)
    options_button.pressed.connect(_on_options_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    
    # Set initial focus for keyboard navigation
    new_game_button.grab_focus()
    
    # Handle controller input
    set_process_unhandled_input(true)

func _unhandled_input(event):
    # Controller navigation support
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

func _on_new_game_pressed():
    # Fade out before transitioning
    create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
    await get_tree().create_timer(0.5).timeout
    get_tree().change_scene_to_file("res://main_node.tscn")

func _on_load_game_pressed():
    pass
    # Implement save loading logic
    # SaveManager.load_latest_save()


    create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
    await get_tree().create_timer(0.5).timeout
    get_tree().change_scene_to_file("res://main_node.tscn")

func _on_options_pressed():
    pass
    # var options_menu = preload("res://ui/options_menu.tscn").instantiate()
    # add_child(options_menu)

func _on_quit_pressed():
    get_tree().quit()