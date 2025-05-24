extends Node


var known_stances: Array[Stance]
var current_stance: Stance = null

func add_stance(stance: Stance) -> void:
	known_stances.append(stance)

func enter_stance(stance: Stance) -> void:
	# enter the stance and add the modifiers to the modifiers component
	current_stance = stance

	for modifier in stance.modifiers:
		match modifier.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)).add_melee_combat_modifier(modifier)
			_:
				pass