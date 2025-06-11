class_name PowderComponent
extends ItemComponent

@export var buff: Buff

## Number of max uses
@export var max_uses: int

## Number of current uses left
@export var current_uses: int


func on_use(_item: ItemResource, _user: Node2D, _target: Variant) -> void:
	var weapon = ComponentRegistry.get_component(_target, GameData.ComponentKeys.EQUIPMENT).equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND]
	if !weapon:
		print("can't use powder without weapon")
		# TODO: show alert message that item was not used
		return
	
	var target_modifier_comp: ModifiersComponent = ComponentRegistry.get_component(_target, GameData.ComponentKeys.MODIFIERS)

	var modifiers = buff.modifiers

	for mod in modifiers:
		# set current weapon for condition to use powder
		var weapon_condition = WeaponCondition.new(weapon)

		# add condition
		mod.conditions.append(weapon_condition)

	target_modifier_comp.add_buff(buff)
	current_uses -= 1
