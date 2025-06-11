class_name Monster
extends Node2D

func get_component(component_key: int) -> Node:
    return get_node("Components").get_node(GameData.get_component_name(component_key))