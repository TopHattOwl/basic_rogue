class_name MeleeWeaponComponent
extends ItemComponent

@export var damage_min: int
@export var damage_max: int

@export var weapon_type: int # from enum WEAPON_TYPES (sword, axe, mace...)
@export var weapon_sub_type: int # from enum WEAPON_SUBTYPES, -1 if not applicable

@export var attack_type: int # from enum ATTACK_TYPE (slash, bash, pierce...)
@export var element: int # from enum ELEMENT

@export var bonuses: Array[StatModifier]

func on_equip(_item: ItemResource, entity: Node2D) -> void:
    var melee_combat_comp = entity.MeleeCombatComp

    if !melee_combat_comp:
        push_error("Entity has no melee combat component")
        return
    
    # apply melee combat stats
    melee_combat_comp.damage_min = damage_min
    melee_combat_comp.damage_max = damage_max

    melee_combat_comp.attack_type = attack_type
    melee_combat_comp.element = element

    # apply bonuses
    if bonuses.size() == 0:
        return

    var modifiers_commp = entity.ModifiersComp
    if !modifiers_commp:
        push_error("Entity has no modifiers component")
        return
    for bonus in bonuses:
        modifiers_commp.add_modifier(bonus)


func on_unequip(_item: ItemResource, entity: Node2D) -> void:

    # reset melee combat stats to base
    var melee_combat_comp = entity.MeleeCombatComp
    if !melee_combat_comp:
        push_error("Entity has no melee combat component")
        return

    melee_combat_comp.reset_to_unarmed()
    # remove modifiers
    var modifiers_commp = entity.ModifiersComp
    if !modifiers_commp:
        push_error("Entity has no modifiers component")
        return
    for bonus in bonuses:
        modifiers_commp.remove_modifier(bonus)

