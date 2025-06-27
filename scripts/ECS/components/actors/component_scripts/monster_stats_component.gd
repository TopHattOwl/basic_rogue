class_name MonsterStatsComponent
extends Node


var monster_tier: int = 1
var monster_id: int = 0
var monster_uid: String = ""


func initialize(d: Dictionary) -> void:

    monster_tier = d.get("monster_tier", 1)
    monster_id = d.get("monster_id", 0)
    monster_uid = d.get("monster_uid", "")