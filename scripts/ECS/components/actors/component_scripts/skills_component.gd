class_name SkillsComponent
extends Node

var skills: Dictionary = {}

# skill var setup
# skills = {
# 	SkilltreeId: SkillTreeData object
#
# 	EXAMPLE
# 	GameData.SKILLS.SWORD: Object: Sword skill tree
# }


func _ready() -> void:
	for skill_id in GameData.SKILLS.values():
		skills[skill_id] = SkillTreeData.new(skill_id)

## adds exp to skill tree
func add_exp(skill_id: int, _exp_gain: int) -> void:
	var skill: SkillTreeData = skills[skill_id]


	var remaning_exp = _exp_gain

	while remaning_exp > 0:
		var exp_needed = skill.exp_for_next_level - skill.current_exp

		if exp_needed <= remaning_exp:
			remaning_exp -= exp_needed
			level_up_skill(skill_id)
		else:
			skill.current_exp += remaning_exp
			remaning_exp = 0
			break

## levels up skill tree
func level_up_skill(skill_id: int) -> void:
	var skill: SkillTreeData = skills[skill_id]

	skill.level += 1
	skill.current_exp = 0
	skill.skill_points += 1

	skill.exp_for_next_level = skill.exp_formula.call(skill.level)

	if get_parent().get_parent() == GameData.player:
		SignalBus.skill_leveled_up.emit(skill_id)


func unlock_passive(skill_id: int, passive_id: int, debug_mode: bool = false) -> bool:
	var skill_tree_data: SkillTreeData = skills[skill_id]
	var passive = SkillFactory.get_passive(passive_id)

	if not passive:
		push_error("No passive with ID: ", passive_id)
		return false

	if passive_id in skill_tree_data.unlocked_passives:
		return false

	if debug_mode:
		skill_tree_data.unlocked_passives.append(passive_id)
		passive.apply_to(get_parent().get_parent())
		return true

	# requirement checks
	if passive.required_skill_level > skill_tree_data.level:
		return false
	if passive.skill_point_cost > skill_tree_data.skill_points:
		return false

	skill_tree_data.skill_points -= passive.skill_point_cost
	skill_tree_data.unlocked_passives.append(passive_id)

	passive.apply_to(get_parent().get_parent())

	return true

func save_skills() -> Dictionary:
	return skills

func load_skills(_d: Dictionary) -> void:
	pass

class SkillTreeData:
	var level: int = 1
	var current_exp: int = 0
	var exp_for_next_level: int = 600
	var skill_points: int = 0
	var unlocked_passives: Array = []
	var skill_tree_name: String
	var skill_id: int

	var exp_formula: Callable = func(lvl): return 305 + 201.25 * lvl + pow(lvl, 2) * 124.1071

	func _init(_skill_id: int) -> void:
		skill_id = skill_id
		skill_tree_name = GameData.SKILL_NAMES[_skill_id]
