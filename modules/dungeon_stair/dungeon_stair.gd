class_name DungeonStair
extends Resource

var is_up: bool
var depth: int

func _init(data: Dictionary = {}) -> void:
    is_up = data.get("is_up", false)
    depth = data.get("depth", 0)
