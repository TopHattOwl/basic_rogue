class_name Stance
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var weapon_types: Array
@export var armor_types: Array
@export var modifiers: Array[StatModifier]

# var modifier_template = {
#     "modified_comp": int from enum ComponentKeys,
#     "modified_thing": StringName name of the variable that will be modified,
#     "modifier": float multiplier
# }