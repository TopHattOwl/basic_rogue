class_name StatModifier
extends Resource

@export var target_stat: StringName
@export var target_component: int # from enum ComponentKeys
@export var operation: int # Enum: ADD, MULTIPLY, OVERRIDE, also will be used for priority
@export var value: float