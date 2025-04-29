class_name AttributesComponent
extends Node

var strength: int = 10:
    set(value):
        strength = max(1, value)
var dexterity: int = 10:
    set(value):
        dexterity = max(1, value)
var intelligence: int = 10:
    set(value):
        intelligence = max(1, value)
var constitution: int = 10:
    set(value):
        constitution = max(1, value)

var strength_modifier: int = (strength - 10)/2
var dexterity_modifier: int = (dexterity - 10)/2
var intelligence_modifier: int = (intelligence - 10)/2
var constitution_modifier: int = (constitution - 10)/2

func initialize(attributes: Dictionary):
    strength = attributes.get("strength")
    dexterity = attributes.get("dexterity")
    intelligence = attributes.get("intelligence")
    constitution = attributes.get("constitution")

    update_modifiers()


func update_modifiers():
    strength_modifier = (strength - 10)/2
    dexterity_modifier = (dexterity - 10)/2
    intelligence_modifier = (intelligence - 10)/2
    constitution_modifier = (constitution - 10)/2

func raise_attribute(attribute: int):
    match attribute:
        GameData.ATTRIBUTES.STRENGTH:
            strength += 1
        GameData.ATTRIBUTES.DEXTERITY:
            dexterity += 1
        GameData.ATTRIBUTES.INTELLIGENCE:
            intelligence += 1
        GameData.ATTRIBUTES.CONSTITUTION:
            constitution += 1

    update_modifiers()

func set_all_attributes(strength_value: int, dexterity_value: int, intelligence_value: int, constitution_value: int):
    strength = max(1, strength_value)
    dexterity = max(1, dexterity_value)
    intelligence = max(1, intelligence_value)
    constitution = max(1, constitution_value)

    update_modifiers()

func set_attribute(attribute: int, value: int):
    match attribute:
        GameData.ATTRIBUTES.STRENGTH:
            strength = max(1, value)
        GameData.ATTRIBUTES.DEXTERITY:
            dexterity = max(1, value)
        GameData.ATTRIBUTES.INTELLIGENCE:
            intelligence = max(1, value)
        GameData.ATTRIBUTES.CONSTITUTION:
            constitution = max(1, value)

    update_modifiers()

func get_weapon_damage_bonus_from_scaling(scaling: int) -> int:
    match scaling:
        GameData.ATTRIBUTES.STRENGTH:
            return strength_modifier
        GameData.ATTRIBUTES.DEXTERITY:
            return dexterity_modifier
        GameData.ATTRIBUTES.INTELLIGENCE:
            return intelligence_modifier
        GameData.ATTRIBUTES.CONSTITUTION:
            return constitution_modifier
    
    return 0