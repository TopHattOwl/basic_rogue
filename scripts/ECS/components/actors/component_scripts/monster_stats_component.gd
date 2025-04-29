class_name MonsterStatsComponent
extends Node

var armor: int = 0

# gets set at spawn
var monster_id: int = 0


func initialize(d: Dictionary) -> void:
    armor = d.get("armor", 0)