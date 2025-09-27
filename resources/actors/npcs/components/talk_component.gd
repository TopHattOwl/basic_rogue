class_name TalkComponent
extends Node


var is_talking: bool = false
var conversation_tree_json_path: String
var conversation_tree: Dictionary = {}


func initialize(d: Dictionary) -> void:
	conversation_tree_json_path = d.get("conversation_tree_json_path", "")
	parse_json()


func parse_json() -> void:
	conversation_tree = JSON.parse_string(FileAccess.get_file_as_string(conversation_tree_json_path))


func get_conversation_data() -> Dictionary:
	return conversation_tree
