class_name MeleeWeaponComponent
extends ItemComponent

@export var damage_min: int
@export var damage_max: int

@export var weapon_type: int # from enum WEAPON_TYPES (sword, axe, mace...)
@export var weapon_sub_type: int # from enum WEAPON_SUBTYPES, -1 if not applicable

@export var attack_type: int # from enum ATTACK_TYPE (slash, bash, pierce...)
@export var element: int # from enum ELEMENT

func get_base_damage() -> int:
    return randi_range(damage_min, damage_max)