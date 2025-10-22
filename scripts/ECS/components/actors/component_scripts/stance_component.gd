class_name StanceComponent
extends Node


var known_stances: Array[Stance]
var current_stance: Stance = null

func add_stance(stance: Stance) -> void:
	known_stances.append(stance)


## enter a stance [br]
## if cant enter retrun false [br]
## if can enter return true 
func enter_stance(stance: Stance) -> bool:
	var debug := GameData.stance_debug
	# checks
	if stance == null:
		return false
	if stance == current_stance:
		if debug:
			print("[StanceComponent.enter_stance] stance already active, not entering")
		return false
		
	if stance not in known_stances:
		if debug:
			print("[StanceComponent.enter_stance] stance not in known stances, not entering")
		return false
	
	if !check_stance_requirements(stance):
		if debug:
			print("[StanceComponent.enter_stance] stance requirements not met, not entering")
		return false

	# if check passed enter stance
	if current_stance != null:
		exit_stance()

	
	# enter the stance and add the modifiers to the modifiers component
	current_stance = stance

	if debug:
		print("[StanceComponent.enter_stance] entered stance, adding modifiers, stance name: ", current_stance.name)
	for modifier in stance.modifiers:
		match modifier.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				if debug:
					print("\t[StanceComponent.enter_stance] adding modifier for stat: ", modifier.target_stat)
				var modifiers_comp: ModifiersComponent = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS))
				modifiers_comp.add_modifier(modifier)
			_:
				pass

	return true

func exit_stance() -> void:
	var debug := GameData.stance_debug

	if debug:
		print("[StanceComponent.exit_stance] exiting stance and removing modifiers")
	# exit the stance and remove the modifiers
	for modifier in current_stance.modifiers:
		match modifier.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				if debug:
					print("[StanceComponent.exit_stance] removing modifier: ", modifier)
				get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)).remove_modifier(modifier)
			_:
				pass

	current_stance = null

## check requirements for the stance, returns true if all requirements are met
func check_stance_requirements(stance: Stance) -> bool:
	var debug := GameData.stance_debug
	var equipment_comp = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
	var main_hand: ItemResource = equipment_comp.equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND]
	
	if not main_hand:
		if debug:
			print("[StanceComponent.check_stance_requirements] no main hand weapon equipped")
		return false
	
	if not stance.weapon_types.has(main_hand.get_component(MeleeWeaponComponent).weapon_type):
		if debug:
			print("[StanceComponent.check_stance_requirements] weapon type is nit suppored by stance")
		return false

	return true
