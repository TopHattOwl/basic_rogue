class_name ModifierFactory
extends Node
## creates modifier instances dynamically

## returns the new modifier inside an array
## if target_stat is damage_min returns an array for damage min and max
static func make_modifier(
	target_component: int = GameData.ComponentKeys.MELEE_COMBAT,
	target_stat: String = "damage_min",
	operation: int = GameData.MODIFIER_OPERATION.ADD,
	value: float = 10.0,
	conditions: Array = []
) -> Array:

	var modifier = StatModifier.new()
	modifier.target_component = target_component
	modifier.target_stat = target_stat
	modifier.operation = operation
	modifier.value = value
	modifier.conditions = conditions

	if target_stat == "damage_min":
		var modifier_2 = StatModifier.new()
		modifier_2.target_component = target_component
		modifier_2.target_stat = "damage_max"
		modifier_2.operation = operation
		modifier_2.value = value
		modifier_2.conditions = conditions

		return [modifier, modifier_2]
	

	return [modifier]
