class_name WeaponStatsComponent
extends Node


var damage: Array = [1, 4, []]
var scaling: int = GameData.ATTRIBUTES.STRENGTH
var attack_type: int = 0
var element: int = 0
var to_hit_bonus: int = 1
var weapon_type: int = 0
var weapon_subtype: int = 0


func initialize(d: Dictionary) -> void:
    damage = d.get("damage", [1, 4, []])
    scaling = d.get("scaling", GameData.ATTRIBUTES.STRENGTH)
    attack_type = d.get("attack_type", 0)
    element = d.get("element", 0)
    to_hit_bonus = d.get("to_hit_bonus", 1)
    weapon_type = d.get("weapon_type", 0)
    weapon_subtype = d.get("weapon_subtype", 0)

