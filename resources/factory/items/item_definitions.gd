extends Node


func _ready() -> void:
	ItemFactory.set_component_map()

## Get item definition by ID [br]
## `Param item_id` should come from ItemDefinitions.ITEMS
func get_item_definition(item_id: int) -> Dictionary:
	if not item_definitions.has(item_id):
		push_error("Item definition not found for ID: " + str(item_id))
		return {}
	return item_definitions[item_id]



## Get all items of a specific type [br]
## `Param item_type` should come from GameData.ITEM_TYPES
func get_items_by_type(item_type: int) -> Dictionary:
	var filtered_items = {}
	for item_id in item_definitions:
		if item_definitions[item_id]["base_data"]["item_type"] == item_type:
			filtered_items[item_id] = item_definitions[item_id]
	return filtered_items



var item_definitions: Dictionary = {
	# ====================
	# WEAPONS
	# ====================

	#   -- Swords --
	ITEMS.IRON_LONGSWORD: {
		"base_data": {
			"id": ITEMS.IRON_LONGSWORD,
			"uid": ITEMS.keys()[ITEMS.IRON_LONGSWORD],
			"display_name": "Iron Longsword",
			"description": "A simple iron longsword",
			"item_type": GameData.ITEM_TYPES.WEAPON,
			"sprite_path": "res://assets/items/weapons/steel_londsword.png",
			"rarity": GameData.RARITY.COMMON,
			"value": 15,
		},
		"components": {
			"MeleeWeaponComponent": {
				"damage_min": 9,
				"damage_max": 14,
				"weapon_type": GameData.WEAPON_TYPES.SWORD,
				"weapon_sub_type": GameData.WEAPON_SUBTYPES.SWORD_2H,
				"attac-Type": GameData.ATTACK_TYPE.SLASH,
				"element": GameData.ELEMENT.PHYSICAL,
				"bonuses": [
					
				],
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.MAIN_HAND,
			},
			"CapacityComponent": {
				"max_capacity": 49,
 			},
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},

		}

	},
	ITEMS.STEEL_LONGSWORD: {

	},

	#   -- Axes --
	ITEMS.IRON_BATTLEAXE: {

	},
	ITEMS.STEEL_BATTLEAXE: {

	},

	#   -- Polearms --
	ITEMS.IRON_POLEAXE: {

	},

	# ====================
	# ARMOR
	# ====================

	#   -- Chest slot --
	ITEMS.IRON_CHESTPLATE: {

	},
	ITEMS.STEEL_CHESTPLATE: {

	},

	#   -- Head slot --
	ITEMS.STEEL_HELMET: {
		"base_data": {
			"id": ITEMS.STEEL_HELMET,
			"uid": ITEMS.keys()[ITEMS.STEEL_HELMET],
			"display_name": "Steel Helmet",
			"description": "A simple steel helmet",
			"item_type": GameData.ITEM_TYPES.ARMOR,
			"sprite_path": "res://assets/items/armor/head/steel_helmet.png",
			"rarity": GameData.RARITY.COMMON,
			"value": 20,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"ArmorComponent": {
				"armor": 10,
				"resistances": {
					GameData.ELEMENT.FIRE: 0.08,
					GameData.ELEMENT.LIGHTNING: 0.12,
				}
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.HEAD,
			},
			"CapacityComponent": {
				"max_capacity": 25,
 			},
		}
	},

	#   -- Legs slot --
	ITEMS.IRON_GREAVES: {

	},

	# 	-- Hands slot --
	ITEMS.STEEL_GAUNTLETS: {
		"base_data": {
			"id": ITEMS.STEEL_GAUNTLETS,
			"uid": ITEMS.keys()[ITEMS.STEEL_GAUNTLETS],
			"display_name": "Steel gauntlets",
			"description": "simple steel gauntlets",
			"item_type": GameData.ITEM_TYPES.ARMOR,
			"sprite_path": "res://assets/items/armor/hands/steel_gloves.png",
			"rarity": GameData.RARITY.COMMON,
			"value": 18,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"ArmorComponent": {
				"armor": 7,
				"resistances": {
					GameData.ELEMENT.FIRE: 0.04,
				}
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.HANDS,
			},
			"CapacityComponent": {
				"max_capacity": 14,
 			},
		}
	},

	#   -- Belt slot --
	ITEMS.LEATHER_BELT: {

	},

	# 	-- Cloak slot --
	ITEMS.CLOAK: {
		"base_data": {
			"id": ITEMS.CLOAK,
			"uid": ITEMS.keys()[ITEMS.CLOAK],
			"display_name": "Cloak",
			"description": "A simple travel cloak",
			"item_type": GameData.ITEM_TYPES.ARMOR,
			"sprite_path": "res://assets/items/armor/neck/cloak.png",
			"rarity": GameData.RARITY.COMMON,
			"value": 15,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"ArmorComponent": {
				"armor": 5,
				"resistances": {
					GameData.ELEMENT.ICE: 0.04,
				}
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.NECK,
			},
			"CapacityComponent": {
				"max_capacity": 0,
 			},
		}
	},

	#   -- Chest under slot --
	ITEMS.GAMBESON: {

	},


	# ====================
	# POTIONS
	# ====================

	
	# ====================
	# POWDER
	# ====================

	ITEMS.TEST_POWDER: {
		"base_data": {
			"id": ITEMS.TEST_POWDER,
			"uid": ITEMS.keys()[ITEMS.TEST_POWDER],
			"display_name": "Test Powder",
			"description": "A simple test powder",
			"item_type": GameData.ITEM_TYPES.POWDER,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 10,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"PowderComponent": {
				"max_uses": 3,
				"buff": BuffFactory.make_buff({
					"duration": 15,
					"buff_name": "Test Buff",
					"buff_sprite_path": "",
					"description": "test buff for test powder",
					"modifiers": ModifierFactory.make_batch_modifiers([
						{
							"target_stat": "damage_min",
							"target_component": GameData.ComponentKeys.MELEE_COMBAT,
							"operation": GameData.MODIFIER_OPERATION.ADD,
							"value": 10.0,
						},
						{
							"target_stat": "element",
							"target_component": GameData.ComponentKeys.MELEE_COMBAT,
							"operation": GameData.MODIFIER_OPERATION.OVERRIDE,
							"value": GameData.ELEMENT.ICE,
						},
					]),
				}),
			}
		},
	},


	# ====================
	# RESOURCES
	# ====================

	ITEMS.IRON_LUMP: {
		"base_data": {
			"id": ITEMS.IRON_LUMP,
			"uid": ITEMS.keys()[ITEMS.TEST_POWDER],
			"display_name": "Iron lump",
			"description": "A lump of iron",
			"item_type": GameData.ITEM_TYPES.RESOURCE,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 10,
		},

		"components": {
			"StackableComponent": {
				"is_stackable": true,
				"max_stack_size": 50
			}
		}
	},

}

enum ITEMS {
	# --- WEAPONS ---
	IRON_LONGSWORD,
	STEEL_LONGSWORD,

	IRON_BATTLEAXE,
	STEEL_BATTLEAXE,

	IRON_POLEAXE,

	# --- ARMOR ---
	
	# Chest
	IRON_CHESTPLATE,
	STEEL_CHESTPLATE,

	# Head
	STEEL_HELMET,

	# Legs
	IRON_GREAVES,

	# Hands
	STEEL_GAUNTLETS,

	# Belt
	LEATHER_BELT,

	# Neck
	CLOAK,

	# Chest under
	GAMBESON,

	# --- POWDER ---
	TEST_POWDER,



	# --- RESOURCE ---
	IRON_LUMP,
}
