extends Node2D

@onready var components = $Components
var item_identity_comp: Node = null
var item_position_comp: Node = null
var weapon_stats_cop: Node = null

var stats = {
	GameData.ComponentKeys.ITEM_IDENTITY: {
		"item_type": GameData.ITEM_TYPES.WEAPON,
		"item_name": "Steel Longsword",
		"price": 40
	},
	GameData.ComponentKeys.ITEM_POSITION: {
		
	},
	GameData.ComponentKeys.WEAPON_STATS: {
		"damage": [1, 6, []],
		"scaling": GameData.ATTRIBUTES.STRENGTH,
		"attack_type": GameData.ATTACK_TYPE.SLASH,
		"element": GameData.ELEMENT.PHYSICAL,
		"to_hit_bonus": 2,
		"weapon_type": GameData.WEAPON_TYPES.SWORD,
		"weapon_subtype": GameData.WEAPON_SUBTYPES.SWORD_2H
	},
}

func _ready():
	# set component variables
	item_identity_comp = get_componenet(GameData.ComponentKeys.ITEM_IDENTITY)
	item_position_comp = get_componenet(GameData.ComponentKeys.ITEM_POSITION)

	weapon_stats_cop = get_componenet(GameData.ComponentKeys.WEAPON_STATS)

	# initialize component data
	ComponentRegistry.init_weapon_components(self, stats)
	

func get_componenet(key: int):
	print("getting component:", key)
	return components.get_node(GameData.get_component_name(key))
