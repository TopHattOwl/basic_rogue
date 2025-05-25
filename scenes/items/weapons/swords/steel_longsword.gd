extends Node2D

@onready var components = $Components
var item_identity_comp: Node = null
var item_position_comp: Node = null
var item_skill_comp: Node = null
var weapon_stats_comp: Node = null


var stats = {
	GameData.ComponentKeys.ITEM_IDENTITY: {
		"item_type": GameData.ITEM_TYPES.WEAPON,
		"item_name": "Steel Longsword",
		"price": 40
	},

	GameData.ComponentKeys.WEAPON_STATS: {
		"damage_min": 10,
		"damage_max": 16,
		"scaling": GameData.ATTRIBUTES.STRENGTH,
		"attack_type": GameData.ATTACK_TYPE.SLASH,
		"element": GameData.ELEMENT.PHYSICAL,
		"weapon_type": GameData.WEAPON_TYPES.SWORD,
		"weapon_subtype": GameData.WEAPON_SUBTYPES.SWORD_2H
	},
	
	GameData.ComponentKeys.ITEM_SKILL: {
		"skill": GameData.SKILLS.SWORD
	}
}


func _ready():
	# set component variables
	item_identity_comp = get_componenet(GameData.ComponentKeys.ITEM_IDENTITY)
	item_position_comp = get_componenet(GameData.ComponentKeys.ITEM_POSITION)
	item_skill_comp = get_componenet(GameData.ComponentKeys.ITEM_SKILL)

	weapon_stats_comp = get_componenet(GameData.ComponentKeys.WEAPON_STATS)

	# initialize component data
	ComponentRegistry.init_weapon_components(self, stats)
	

func get_componenet(key: int):
	return components.get_node(GameData.get_component_name(key))


