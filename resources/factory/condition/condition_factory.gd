class_name ConditionFactory
extends Node

## Weapon type is from GameData.WEAPON_TYPES
static func make_weapon_type_condition(weapon_type: int) -> Condition:
    return WeaponTypeCondition.new(weapon_type)

static func make_block_condition(_duration: int, _owner: Node2D) -> Condition:
    return BlockCondition.new(_duration, _owner)

static func make_weapon_condition(_required_weapon: ItemResource) -> Condition:
    return WeaponCondition.new(_required_weapon)
    