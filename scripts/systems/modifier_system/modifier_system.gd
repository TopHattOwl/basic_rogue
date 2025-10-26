class_name ModifierSystem
extends Node

## returns the modified value, Does not modifiy the base value, returns a new value [br]
## `param stat` should be the name of the stat you want to modify 
static func get_modified_value(entity: Node2D, stat: StringName, target_component: int) -> Variant:

	return get_modified_component_value(entity, stat, target_component)

# --- MELEE COMBAT MODIFIERS---
# damage min and damage max is changed with the same value every time -> in game a damage increase of 5 mean damage min + 5 and damage max + 5

static func get_modified_component_value(entity: Node2D, stat: StringName, target_component: int) -> Variant:
	var modifiers = _get_relevant_modifiers(entity, stat, target_component)

	if modifiers.is_empty():
		return ComponentRegistry.get_component(entity, target_component).get(stat)

	var base_value = ComponentRegistry.get_component(entity, target_component).get(stat)
	var current = base_value

	for mod in modifiers:
		current = _apply_modifier(current, mod)

	return current

static func _apply_modifier(_current: Variant, _mod: StatModifier) -> float:
	match _mod.operation:
		GameData.MODIFIER_OPERATION.ADD:
			return _current + _mod.value
		GameData.MODIFIER_OPERATION.MULTIPLY:
			return _current * _mod.value

		# can only override values represented by numbers (even if value is represented by enum, like element type)
		GameData.MODIFIER_OPERATION.OVERRIDE:
			return _mod.value
			
		_:
			return _current

static func _get_relevant_modifiers(entity: Node2D, stat: StringName, target_component: int) -> Array:
	var modifiers = null
	match target_component:
		GameData.ComponentKeys.MELEE_COMBAT:
			modifiers = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS).melee_combat_modifiers
		GameData.ComponentKeys.BLOCK:
			modifiers = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS).block_modifiers
		GameData.ComponentKeys.STAMINA:
			modifiers = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS).stamina_modifiers
		GameData.ComponentKeys.ENERGY:
			modifiers = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS).energy_modifiers
		_:
			push_error("[ModifierSystem] Invalid target component: ", target_component)
			return []

	return modifiers.filter(
		func(mod): return mod.target_stat == stat and _check_conditions(mod, entity)
	)

static func _check_conditions(mod: StatModifier, _entity: Node2D) -> bool:
	for condition in mod.conditions:
		if not condition.is_met(_entity):
			return false
	return true
