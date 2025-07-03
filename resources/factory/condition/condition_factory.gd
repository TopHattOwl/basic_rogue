class_name ConditionFactory
extends Node

## Weapon type is from GameData.WEAPON_TYPES
static func make_weapon_type_condition(weapon_type: int) -> Condition:
    return WeaponTypeCondition.new(weapon_type)