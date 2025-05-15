extends Node


var loot_pool = []

func initialize(d: Dictionary) -> void:
    loot_pool = d.get("loot_pool", [])