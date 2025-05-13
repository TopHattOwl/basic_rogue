extends Node

func log_message(text: String) -> void:
	GameData.player.get_node("PlayerUI").log_message(text)
