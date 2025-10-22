class_name ModifierFactory
extends Node
## creates modifier instances dynamically

# ## returns the new modifier inside an array
# ## if target_stat is damage_min returns an array for damage min and max
# static func make_modifiers(
# 	target_component: int = GameData.ComponentKeys.MELEE_COMBAT,
# 	target_stat: String = "damage_min",
# 	operation: int = GameData.MODIFIER_OPERATION.ADD,
# 	value: float = 10.0,
# 	conditions: Array = []
# ) -> Array:

# 	var modifier = StatModifier.new()
# 	modifier.target_component = target_component
# 	modifier.target_stat = target_stat
# 	modifier.operation = operation
# 	modifier.value = value
# 	modifier.conditions = conditions

# 	if target_stat == "damage_min":
# 		var modifier_2 = StatModifier.new()
# 		modifier_2.target_component = target_component
# 		modifier_2.target_stat = "damage_max"
# 		modifier_2.operation = operation
# 		modifier_2.value = value
# 		modifier_2.conditions = conditions

# 		return [modifier, modifier_2]
	

# 	return [modifier]

## Makes an array of modifiers with given definitions [br]
## ### !!! for damage modifier, only damage_min is required, damage_max is added automatically
static func make_batch_modifiers(definitions: Array) -> Array[StatModifier]:
	var all_mods: Array[StatModifier] = []

	for def in definitions:
		all_mods.append_array(make_singe_modifier(def))

	return all_mods

## makes a single modifier inside an array[br]
## If damage_min is given as `target_stat` returns an array for damage min and max
static func make_singe_modifier(d: Dictionary = {}) -> Array[StatModifier]:
	var modifiers: Array[StatModifier] = []

	var modifier = StatModifier.new()
	modifier.target_component = d.get("target_component", GameData.ComponentKeys.MELEE_COMBAT)
	modifier.target_stat = d.get("target_stat", "damage_min")
	modifier.operation = d.get("operation", GameData.MODIFIER_OPERATION.ADD)
	modifier.value = d.get("value", 10)
	modifier.conditions = d.get("conditions", [])

	modifiers.append(modifier)

	# if damage_min, add damage_max
	if modifier.target_stat == "damage_min":
		var damage_max_modifier = StatModifier.new()
		damage_max_modifier.target_component = modifier.target_component
		damage_max_modifier.target_stat = "damage_max"
		damage_max_modifier.operation = modifier.operation
		damage_max_modifier.value = modifier.value
		damage_max_modifier.conditions = modifier.conditions

		modifiers.append(damage_max_modifier)

	return modifiers
