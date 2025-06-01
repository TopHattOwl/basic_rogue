class_name SkillsComponent
extends Node

var skill_levels: Dictionary = {
	GameData.SKILLS.SWORD: {
		"level": 1,
		"current_exp": 0,
		"exp_for_next_level": 250,
	},
	GameData.SKILLS.AXE: {
		"level": 1,
		"current_exp": 0,
		"exp_for_next_level": 250,
	},
	GameData.SKILLS.SPEAR: {
		"level": 1,
		"current_exp": 0,
		"exp_for_next_level": 250,
	},
	GameData.SKILLS.POLEAXE: {
		"level": 1,
		"current_exp": 0,
		"exp_for_next_level": 250,
	},
	GameData.SKILLS.BOW: {
		"level": 1,
		"current_exp": 0,
		"exp_for_next_level": 250,
	},
}


func _add_exp_to_skill(skill_id: int, exp_gain: int) -> void:
	var skill = skill_levels[skill_id]
	var exp_needed = skill.exp_for_next_level - skill.current_exp

	if exp_needed <= exp_gain:
		skill.level += 1
		skill.current_exp = exp_gain - exp_needed
		skill.exp_for_next_level += 250
	else:
		skill.current_exp += exp_gain
	
