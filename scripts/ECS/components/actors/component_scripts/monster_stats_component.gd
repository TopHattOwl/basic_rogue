class_name MonsterStatsComponent
extends Node

var armor: int = 0

var monster_tier: int = 1
var monster_id: int = 0



func initialize(d: Dictionary) -> void:
    armor = d.get("armor", 0)

    monster_tier = d.get("monster_tier", 1)
    monster_id = d.get("monster_id", 0)