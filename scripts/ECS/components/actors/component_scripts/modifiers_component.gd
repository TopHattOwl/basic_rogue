class_name ModifiersComponent
extends Node

var melee_combat_modifiers: Array[StatModifier]

# temporary buffs that only last for x turns
var buffs = []


# --- MELEE COMBAT ---
func add_melee_combat_modifier(mod: StatModifier) -> void:
    melee_combat_modifiers.append(mod)
    if melee_combat_modifiers.size() > 1:
        melee_combat_modifiers.sort_custom(_sort_priority)

func remove_melee_combat_modifier(mod: StatModifier) -> void:
    melee_combat_modifiers.erase(mod)

func _sort_priority(a: StatModifier, b: StatModifier) -> bool:
    return a.operation < b.operation


