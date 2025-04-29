class_name ItemPositionComponent
extends Node

var grid_pos: Vector2i
var is_on_ground: bool = false

func initialize(d: Dictionary) -> void:
    grid_pos = d.get("grid_pos", Vector2i(0, 0))
    is_on_ground = d.get("is_on_ground", false)