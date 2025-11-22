class_name PowderComponent
extends ItemComponent

@export var buff: Buff

## Number of max uses
@export var max_uses: int:
	set(value):
		max_uses = value
		current_uses = value

## Number of current uses left
@export var current_uses: int


func on_use(_item: ItemResource, _entity: Node2D, _target: Variant = null) -> void:
	var weapon = ComponentRegistry.get_component(_target, GameData.ComponentKeys.EQUIPMENT).equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND]
	if !weapon:
		print("can't use powder without weapon")
		# TODO: show alert message that item was not used
		return
	
	var target_modifier_comp: ModifiersComponent = ComponentRegistry.get_component(_target, GameData.ComponentKeys.MODIFIERS)

	var modifiers = buff.modifiers

	for mod in modifiers:
		# set current weapon for condition to use powder
		var weapon_condition: WeaponCondition = ConditionFactory.make_weapon_condition(weapon)

		# add condition
		mod.conditions.append(weapon_condition)

	target_modifier_comp.add_buff(buff)
	current_uses -= 1


func can_use(_item: ItemResource, _entity: Node2D, _target: Variant = null) -> bool:
	return current_uses > 0
