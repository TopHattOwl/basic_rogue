extends Node
# autoload
# holds data about all skills

enum PASSIVE_IDS {
	# SWORDS
	PLACEHOLDER_SWORD,
	CHILD_OF_PLACEHOLDER,
	CHILD_OF_CHILD_OF_PLACEHOLDER_SWORD,

	# AXE
	PLACEHOLDER_AXE,

	# SPEAR
	PLACEHOLDER_SPEAR,

	# MACE
	PLACEHOLDER_MACE,

	# POLEAXE
	PLACEHOLDER_POLEAXE,

	# BOW
	PLACEHOLDER_BOW,

	# MELEE
	PLACEHOLDER_MELEE,

	# BLOCK
	PLACEHOLDER_BLOCK,
	CHILD_OF_PLACEHOLDER_BLOCK,
	SECOND_CHILD_OF_PLACEHOLDER_BLOCK,

	# FIRE
	PLACEHOLDER_FIRE,
	CHILD_OF_PLACEHOLDER_FIRE,

	# ICE	
	PLACEHOLDER_ICE,

	# LIGHTNING
	PLACEHOLDER_LIGHTNING,

	# BLOOD
	PLACEHOLDER_BLOOD,

	# POISON
	PLACEHOLDER_POISON


}


func _ready() -> void:
	placeholder_icon.size = Vector2(16, 24)
	if GameData.skill_debug:
		print("loading skill definitions\n")
		for skill_type in SKILL_TREES:
			print("skill type: ", GameData.SKILL_NAMES[skill_type], "\n")
			for skill in SKILL_TREES[skill_type]:
				print("skill definition: ", skill["display_name"], "\n")



func get_skill_tree(skill_type: int) -> Array:
	return SKILL_TREES.get(skill_type, [])


func get_passive_definition(passive_id: int) -> Dictionary:
	for skill_type in SKILL_TREES:
		for passive in SKILL_TREES[skill_type]:
			if passive.id == passive_id:
				return passive
	return {}

# ----------------------------------------------------------------------------
var placeholder_icon = PlaceholderTexture2D.new()
var SKILL_TREES = {
	GameData.SKILLS.SWORD: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_SWORD,
			display_name = "Placeholder Sword",
			description = "This is a placeholder passive skill\n adds 15`%` damage if using swords",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = ModifierFactory.make_singe_modifier({
				"operation": GameData.MODIFIER_OPERATION.MULTIPLY,
				"value": 1.15,
				"conditions": [ConditionFactory.make_weapon_type_condition(GameData.WEAPON_TYPES.SWORD)]
			}),
			children = [PASSIVE_IDS.CHILD_OF_PLACEHOLDER]
		},
		{
			id = PASSIVE_IDS.CHILD_OF_PLACEHOLDER,
			display_name = "Child of Placeholder Sword",
			description = "This is a child passive skill, adds 10`%` block chance and 15 damage if using swords",
			icon = placeholder_icon,
			required_skill_level = 2,
			skill_point_cost = 2,
			modifiers = ModifierFactory.make_batch_modifiers([
				{
					"target_component": GameData.ComponentKeys.BLOCK,
					"target_stat": "block_chance",
					"value": 1.1,
					"operation": GameData.MODIFIER_OPERATION.MULTIPLY,
					"conditions": [ConditionFactory.make_weapon_type_condition(GameData.WEAPON_TYPES.SWORD)]
				},
				{
					"value": 15,
					"conditions": [ConditionFactory.make_weapon_type_condition(GameData.WEAPON_TYPES.SWORD)]
				}
			]),
			children = [PASSIVE_IDS.CHILD_OF_CHILD_OF_PLACEHOLDER_SWORD]
		},
		{
			id = PASSIVE_IDS.CHILD_OF_CHILD_OF_PLACEHOLDER_SWORD,
			display_name = "Child of Child of Placeholder Sword",
			description = "This is a child of a child passive skill",
			icon = placeholder_icon,
			required_skill_level = 3,
			skill_point_cost = 3,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.AXE: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_AXE,
			display_name = "Placeholder Axe",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		},

	],

	GameData.SKILLS.SPEAR: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_SPEAR,
			display_name = "Placeholder Spear",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.MACE: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_MACE,
			display_name = "Placeholder Mace",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.POLEAXE: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_POLEAXE,
			display_name = "Placeholder Poleaxe",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.BOW: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_BOW,
			display_name = "Placeholder Bow",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.MELEE: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_MELEE,
			display_name = "Placeholder Melee",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.BLOCK: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_BLOCK,
			display_name = "Placeholder Block",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = [PASSIVE_IDS.CHILD_OF_PLACEHOLDER_BLOCK]
		},
		{
			id = PASSIVE_IDS.CHILD_OF_PLACEHOLDER_BLOCK,
			display_name = "Child of Placeholder Block",
			description = "This is a child passive skill",
			icon = placeholder_icon,
			required_skill_level = 2,
			skill_point_cost = 2,
			modifiers = [],
			children = [PASSIVE_IDS.SECOND_CHILD_OF_PLACEHOLDER_BLOCK]
		},
		{
			id = PASSIVE_IDS.SECOND_CHILD_OF_PLACEHOLDER_BLOCK,
			display_name = "Second Child of Placeholder Block",
			description = "This is a second child passive skill",
			icon = placeholder_icon,
			required_skill_level = 3,
			skill_point_cost = 3,
			modifiers = [],
			children = []
		}
	],

	GameData.SKILLS.FIRE: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_FIRE,
			display_name = "Placeholder Fire",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = [PASSIVE_IDS.CHILD_OF_PLACEHOLDER_FIRE]
		},
		{
			id = PASSIVE_IDS.CHILD_OF_PLACEHOLDER_FIRE,
			display_name = "Child of Placeholder Fire",
			description = "This is a child passive skill",
			icon = placeholder_icon,
			required_skill_level = 2,
			skill_point_cost = 2,
			modifiers = [],
			children = []
		},
	],

	GameData.SKILLS.ICE: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_ICE,
			display_name = "Placeholder Ice",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		},

	],

	GameData.SKILLS.LIGHTNING: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_LIGHTNING,
			display_name = "Placeholder Lightning",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		},
	],

	GameData.SKILLS.BLOOD: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_BLOOD,
			display_name = "Placeholder Lightning",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		},
	],

	GameData.SKILLS.POISON: [
		{
			id = PASSIVE_IDS.PLACEHOLDER_POISON,
			display_name = "Placeholder Lightning",
			description = "This is a placeholder passive skill",
			icon = placeholder_icon,
			required_skill_level = 1,
			skill_point_cost = 1,
			modifiers = [],
			children = []
		},
	],
}
