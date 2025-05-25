class_name WeaponStatsComponent
extends Node


var damage_min: int
var damage_max: int
var scaling: int = GameData.ATTRIBUTES.STRENGTH
var attack_type: int = 0
var element: int = 0
var weapon_type: int = 0
var weapon_subtype: int = 0


func initialize(d: Dictionary) -> void:
    damage_min = d.get("damage_min", 1)
    damage_max = d.get("damage_max", 2)
    scaling = d.get("scaling", GameData.ATTRIBUTES.STRENGTH)
    attack_type = d.get("attack_type", 0)
    element = d.get("element", 0)
    weapon_type = d.get("weapon_type", 0)
    weapon_subtype = d.get("weapon_subtype", 0)

