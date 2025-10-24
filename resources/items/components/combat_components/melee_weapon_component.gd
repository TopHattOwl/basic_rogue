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
    if GameData.item_debug:
        print("--- Bonuses applying start ---")

    if bonuses.size() == 0:
        if GameData.item_debug:
            print("item has no bunuses -> skipp applying bonuses")
        return

    var modifiers_comp = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS)
    # var modifiers_commp = entity.ModifiersComp
    if !modifiers_comp:
        push_error("Entity has no modifiers component")
        return
    for bonus in bonuses:
        if GameData.item_debug:
            print("applying a bonus to entity: ", entity.get_component(GameData.ComponentKeys.IDENTITY).actor_name)
        modifiers_comp.add_modifier(bonus)


func on_unequip(_item: ItemResource, entity: Node2D) -> void:

    # reset melee combat stats to base
    var melee_combat_comp: MeleeCombatComponent = entity.MeleeCombatComp
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

