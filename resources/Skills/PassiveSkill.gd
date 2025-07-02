class_name PassiveSkill
extends RefCounted
## A passive skill is a skill inside a skill tree (each skill type hase separate skill trees)
## data about Passive skills get made inside skill_definitions.gd then 
## Passives get made when game starts, by SkillFactory

var id: int = -1
var skill_type: int # from enum GameData.SKILLS
var display_name: String = "New Passive"
var description: String = "Passive effect description"
var icon: Texture2D
var required_skill_level: int = 1
var skill_point_cost: int = 1
var modifiers: Array = [] # holds StatModifier object or null
var children: Array = []  # ids of children skills


func _init(d: Dictionary) -> void:
	id = d.get("id", -1)
	skill_type = d.get("skill_type", -1)
	display_name = d.get("display_name", "New Passive")
	description = d.get("description", "Passive effect description")
	icon = d.get("icon", null)
	required_skill_level = d.get("required_skill_level", 1)
	skill_point_cost = d.get("skill_point_cost", 1)
	modifiers = d.get("modifiers", [])
	children = d.get("children", [])


func apply_to(entity: Node2D) -> void:
	for mod in modifiers:
		entity.ModifiersComp.add_modifier(mod)

func remove_from(entity: Node2D) -> void:
	for mod in modifiers:
		entity.ModifiersComp.remove_modifier(mod)
