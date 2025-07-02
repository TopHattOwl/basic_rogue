class_name SkillFactory
extends Node
## creates skill instances


static var skills: Dictionary = {}

# skill = {
# 	SkillTreeID: { from enum GameData.SKILLS
# 		passive_id: PassiveSkill,
# 		passive_id: PassiveSkill
# 		...
# 	},


# 	example
# 	GameData.SKILLS.SWORD: {
# 		SkillDefinitions.PASSIVE_IDS.PLACEHOLDER_SWORD: PassiveSkill
# 	}
# }

static func initialize() -> void:

	for skill_type in SkillDefinitions.SKILL_TREES:
		skills[skill_type] = {}
		for passive_def in SkillDefinitions.SKILL_TREES[skill_type]:
			var skill = PassiveSkill.new(passive_def)
			skills[skill_type][skill.id] = skill


static func get_passive(passive_id: int) -> PassiveSkill:
	for skill_type in skills:
		if passive_id in skills[skill_type]:
			return skills[skill_type][passive_id]

	return null


static func get_skill_tree(skill_type: int) -> Dictionary:
	return skills[skill_type]


## prints out the skill tree with children
static func print_skill_tree(skill_type: int):
	var tree = get_skill_tree(skill_type)
	for passive_id in tree:
		var passive = tree[passive_id]
		print(" - %s (ID: %d)" % [passive.display_name, passive.id])
		for child_id in passive.children:
			var child = SkillFactory.get_passive(child_id)
			print("    		-> %s" % child.display_name)
