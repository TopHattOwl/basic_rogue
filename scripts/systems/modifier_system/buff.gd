class_name Buff
extends Resource
## stuff that adds buffs will have a buff object
## ModifiersComponent handles adding/removing buffs (and the modifiers with them)
## if buff is added/removed emits buff_added/buff_removed signal

@export var duration: int
@export var modifiers: Array[StatModifier]

@export var buff_name: String
@export var buff_sprite: Texture2D



