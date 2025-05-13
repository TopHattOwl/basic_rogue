extends Node

var player_ui: CanvasLayer

func set_player_ui():
	player_ui = GameData.player.get_node("PlayerUI")
	print("player ui set: ", player_ui)

func log_message(text: String) -> void:
	player_ui.log_message(text)

func toggle_look_ui() -> void:
	player_ui.toggle_look_ui()

func set_look_ui_texture(texture: Texture2D) -> void:
	player_ui.set_look_ui_texture(texture)
