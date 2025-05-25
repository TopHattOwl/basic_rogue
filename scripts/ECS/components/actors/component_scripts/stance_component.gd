extends Node


var known_stances: Array[Stance]
var current_stance: Stance = null

func add_stance(stance: Stance) -> void:
	known_stances.append(stance)

func enter_stance(stance: Stance) -> bool:
	var equipment_comp = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
	if equipment_comp.weapon == null:
		return false
	# checks
	if stance == null:
		return false
	if stance == current_stance:
		return false
	if stance not in known_stances:
		return false
	if !stance.weapon_types.has(equipment_comp.weapon.weapon_type) or !stance.weapon_types.has(equipment_comp.weapon2.weapon_type):
		return false

	if current_stance != null:
		exit_stance()
	# enter the stance and add the modifiers to the modifiers component
	current_stance = stance


	for modifier in stance.modifiers:
		match modifier.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)).add_melee_combat_modifier(modifier)
			_:
				pass

	return true

func exit_stance() -> void:
	# exit the stance and remove the modifiers
	for modifier in current_stance.modifiers:
		match modifier.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)).remove_melee_combat_modifier(modifier)
			_:
				pass
