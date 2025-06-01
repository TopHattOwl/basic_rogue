class_name ModifierSystem
extends Node

# --- MELEE COMBAT MODIFIERS---
# damage min and damage max is changed with the same value every time -> in game a damage increase of 5 mean damage min + 5 and damage max + 5


static func get_modified_melee_combat_value(entity: Node2D, stat: StringName) -> Variant:
	var modifiers = _get_relevant_melee_combat_modifiers(entity, stat)

	var base_value = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MELEE_COMBAT).get(stat)
	var current = base_value

	for mod in modifiers:
		current = _apply_melee_combat_modifier(current, mod)

	return current

static func _apply_melee_combat_modifier(_current: Variant, _mod: StatModifier) -> float:
	match _mod.operation:
		GameData.MODIFIER_OPERATION.ADD:
			return _current + _mod.value
		GameData.MODIFIER_OPERATION.MULTIPLY:
			return _current * _mod.value
		GameData.MODIFIER_OPERATION.OVERRIDE:
			return _mod.value
		_:
			return _current

static func _get_relevant_melee_combat_modifiers(entity: Node2D, stat: StringName) -> Array:
	var melee_combat_modifiers = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS).melee_combat_modifiers

	return melee_combat_modifiers.filter(
		func(m): return m.target_stat == stat and _check_conditions_melee_combat(m)
	)

static func _check_conditions_melee_combat(mod: StatModifier, _entity: Node2D = null) -> bool:
	for condition in mod.conditions:
		if not condition.is_met():
			return false
	return true

# --- MONSTER COMBAT MODIFIERS---

static func get_modified_monster_melee_combat_value(entity: Node2D, stat: StringName) -> Variant:
	var modifiers = _get_relevant_monster_melee_combat_modifiers(entity, stat)

	var base_value = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MELEE_COMBAT).get(stat)
	var current = base_value

	for mod in modifiers:
		current = _apply_monster_melee_combat_modifier(current, mod)

	return current

static func _apply_monster_melee_combat_modifier(_current: Variant, _mod: StatModifier) -> float:
	match _mod.operation:
		GameData.MODIFIER_OPERATION.ADD:
			return _current + _mod.value
		GameData.MODIFIER_OPERATION.MULTIPLY:
			return _current * _mod.value
		GameData.MODIFIER_OPERATION.OVERRIDE:
			return _mod.value
		_:
			return _current

static func _get_relevant_monster_melee_combat_modifiers(entity: Node2D, stat: StringName) -> Array:
	var melee_combat_modifiers = ComponentRegistry.get_component(entity, GameData.ComponentKeys.MODIFIERS).melee_combat_modifiers

	return melee_combat_modifiers.filter(
		func(m): return m.target_stat == stat and _check_conditions_monster_melee(m)
	)

static func _check_conditions_monster_melee(mod: StatModifier, _entity: Node2D = null) -> bool:
	for condition in mod.conditions:
		if not condition.is_met():
			return false
	return true