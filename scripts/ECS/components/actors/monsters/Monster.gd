class_name Monster
extends Node2D

func get_component(component_key: int) -> Node:
	return get_node("Components").get_node(GameData.get_component_name(component_key))


func connect_signals() -> void:
	SignalBus.fov_calculated.connect(_on_fov_calculated)

func _on_fov_calculated() -> void:

	var monster_pos = get_component(GameData.ComponentKeys.POSITION).grid_pos

	if monster_pos in FovManager.visible_tiles:
		visible = true
	else:
		visible = false
