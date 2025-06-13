extends Node

enum GAME_STATES {
    MAIN_MENU,
    LOADING,
    PLAYING,
}

var game_state: int

func _ready() -> void:
    SignalBus.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(new_state: int) -> void:
    game_state = new_state