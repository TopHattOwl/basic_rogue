class_name ModifiersComponent
extends Node

var melee_combat_modifiers: Array[StatModifier]
var block_modifiers: Array[StatModifier]
var stamina_modifiers: Array[StatModifier]


# temporary buffs that only last for x turns
# not implemented
# replace Variant with Buff class_name
var buffs: Array[Variant]

func add_modifier(mod: StatModifier) -> void:
    match mod.target_component:
        GameData.ComponentKeys.MELEE_COMBAT:
            add_melee_combat_modifier(mod)
        GameData.ComponentKeys.BLOCK:
            pass


func remove_modifier(mod: StatModifier) -> void:
    match mod.target_component:
        GameData.ComponentKeys.MELEE_COMBAT:
            remove_melee_combat_modifier(mod)
        GameData.ComponentKeys.BLOCK:
            pass

# --- MELEE COMBAT ---
func add_melee_combat_modifier(mod: StatModifier) -> void:
    melee_combat_modifiers.append(mod)
    if melee_combat_modifiers.size() > 1:
        melee_combat_modifiers.sort_custom(_sort_priority)

func remove_melee_combat_modifier(mod: StatModifier) -> void:
    melee_combat_modifiers.erase(mod)

func _sort_priority(a: StatModifier, b: StatModifier) -> bool:
    return a.operation < b.operation


