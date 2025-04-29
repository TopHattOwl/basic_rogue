extends Node


var save_player = preload(DirectoryPaths.save_player).new()
var load_player = preload(DirectoryPaths.load_player).new()



func save_player_data(player_node: Node2D):

	save_player.save_player_data(player_node)


func load_player_data(json):
	load_player.load_player_data(json)
