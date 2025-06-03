class_name StatModifier
extends Resource

@export var target_stat: StringName

## from enum ComponentKeys, MELEE_COMBAT = 7,
@export var target_component: int # from enum ComponentKeys
@export var operation: int # Enum: ADD, MULTIPLY, OVERRIDE, also will be used for priority
@export var value: float
@export var conditions: Array[Condition]