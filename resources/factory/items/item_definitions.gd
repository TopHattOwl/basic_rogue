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
				"damage_min": 15,
				"damage_max": 25,
				"weapon_type": GameData.WEAPON_TYPES.SWORD,
				"weapon_sub_type": GameData.WEAPON_SUBTYPES.SWORD_2H,
				"attac-Type": GameData.ATTACK_TYPE.SLASH,
				"element": GameData.ELEMENT.PHYSICAL,
				"bonuses": ModifierFactory.make_singe_modifier({
					"target_component": GameData.ComponentKeys.ENERGY,
					"target_stat": "melee_attack_cost",
					"value": 20,
					"operation": GameData.MODIFIER_OPERATION.ADD, 
				}),
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
		"base_data": {
			"id": ITEMS.STEEL_LONGSWORD,
			"uid": ITEMS.keys()[ITEMS.STEEL_LONGSWORD],
			"display_name": "Steel Longsword",
			"description": "A simple steel longsword",
			"item_type": GameData.ITEM_TYPES.WEAPON,
			"sprite_path": "res://assets/items/weapons/steel_londsword.png",
			"rarity": GameData.RARITY.UNCOMMON,
			"value": 25,
		},
		"components": {
			"MeleeWeaponComponent": {
				"damage_min": 20,
				"damage_max": 29,
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
				"max_capacity": 56,
 			},
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},

		}
	},

	#   -- Axes --

	#   -- Polearms --
	ITEMS.IRON_POLEAXE: {
		"base_data": {
			"id": ITEMS.IRON_POLEAXE,
			"uid": ITEMS.keys()[ITEMS.IRON_POLEAXE],
			"display_name": "Iron Poleaxe",
			"description": "A simple iron poleaxe",
			"item_type": GameData.ITEM_TYPES.WEAPON,
			"sprite_path": "",
			"rarity": GameData.RARITY.UNCOMMON,
			"value": 25,
		},
		"components": {
			"MeleeWeaponComponent": {
				"damage_min": 20,
				"damage_max": 35,
				"weapon_type": GameData.WEAPON_TYPES.POLEARMS,
				"weapon_sub_type": GameData.WEAPON_SUBTYPES.POLEARM_2H,
				"attac-Type": GameData.ATTACK_TYPE.SLASH,
				"element": GameData.ELEMENT.PHYSICAL,
				"bonuses": [
					
				],
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.MAIN_HAND,
			},
			"CapacityComponent": {
				"max_capacity": 58,
 			},
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},

		}
	},

	# -- Daggers --
	ITEMS.STEEL_DAGGER: {
		"base_data": {
			"id": ITEMS.STEEL_DAGGER,
			"uid": ITEMS.keys()[ITEMS.STEEL_DAGGER],
			"display_name": "STEEL_DAGGER",
			"description": "A simple STEEL_DAGGER",
			"item_type": GameData.ITEM_TYPES.WEAPON,
			"sprite_path": "",
			"rarity": GameData.RARITY.UNCOMMON,
			"value": 10,
		},
		"components": {
			"MeleeWeaponComponent": {
				"damage_min": 15,
				"damage_max": 20,
				"weapon_type": GameData.WEAPON_TYPES.DAGGER,
				"weapon_sub_type": GameData.WEAPON_SUBTYPES.DAGGER_1H,
				"attac-Type": GameData.ATTACK_TYPE.PIERCE,
				"element": GameData.ELEMENT.PHYSICAL,
				"bonuses": ModifierFactory.make_singe_modifier({
					"target_component": GameData.ComponentKeys.ENERGY,
					"target_stat": "melee_attack_cost",
					"value": -30,
					"operation": GameData.MODIFIER_OPERATION.ADD, 
				}),
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.MAIN_HAND,
			},
			"CapacityComponent": {
				"max_capacity": 38,
 			},
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},

		}
	},


	# ====================
	# SHIELDS
	# ====================

	ITEMS.ROUND_SHIELD: {
		"base_data": {
			"id": ITEMS.ROUND_SHIELD,
			"uid": ITEMS.keys()[ITEMS.ROUND_SHIELD],
			"display_name": "Round Shield",
			"description": "A wooden round shield",
			"item_type": GameData.ITEM_TYPES.SHIELD,
			"sprite_path": "res://assets/items/shields/round_shield.png",
			"rarity": GameData.RARITY.COMMON,
			"value": 17,
		},
		"components": {
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.OFF_HAND,
			},
			"ShieldComponent": {

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

	# ====================
	# ARMOR
	# ====================

	#   -- Chest slot --
	ITEMS.IRON_CHESTPLATE: {
		"base_data": {
			"id": ITEMS.IRON_CHESTPLATE,
			"uid": ITEMS.keys()[ITEMS.IRON_CHESTPLATE],
			"display_name": "Iron Chestplate",
			"description": "A simple asdasdasd",
			"item_type": GameData.ITEM_TYPES.ARMOR,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 21,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"ArmorComponent": {
				"armor": 20,
				"resistances": {
					GameData.ELEMENT.FIRE: 0.10,
					GameData.ELEMENT.POISON: 0.12,
				}
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.CHEST,
			},
			"CapacityComponent": {
				"max_capacity": 30,
 			},
		}
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
		"base_data": {
			"id": ITEMS.IRON_GREAVES,
			"uid": ITEMS.keys()[ITEMS.IRON_GREAVES],
			"display_name": "IRON_GREAVES",
			"description": "simple IRON_GREAVES",
			"item_type": GameData.ITEM_TYPES.ARMOR,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 12,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"ArmorComponent": {
				"armor": 12,
				"resistances": {
					GameData.ELEMENT.FIRE: 0.05,
					GameData.ELEMENT.BLOOD: 0.06,
				}
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.FEET,
			},
			"CapacityComponent": {
				"max_capacity": 17,
 			},
		}
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
		"base_data": {
			"id": ITEMS.LEATHER_BELT,
			"uid": ITEMS.keys()[ITEMS.LEATHER_BELT],
			"display_name": "Leather Belt",
			"description": "A leather belt, makes wearing armor easier.",
			"item_type": GameData.ITEM_TYPES.ARMOR,
			"sprite_path": "res://assets/items/armor/belt/leather_belt.png",
			"rarity": GameData.RARITY.COMMON,
			"value": 7,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"ArmorComponent": {
				"armor": 0,
				"resistances": {
					
				}
			},
			"EquipableComponent": {
				"equipment_slot": GameData.EQUIPMENT_SLOTS.BELT,
			},
			"CapacityComponent": {
				"max_capacity": 0,
 			},
		}
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

	ITEMS.SUPER_COOL_POWDER: {
		"base_data": {
			"id": ITEMS.SUPER_COOL_POWDER,
			"uid": ITEMS.keys()[ITEMS.SUPER_COOL_POWDER],
			"display_name": "Test Powder 2",
			"description": "A super cool test powder",
			"item_type": GameData.ITEM_TYPES.POWDER,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 99,
		},
		"components": {
			"StackableComponent": {
				"is_stackable": false,
				"max_stack_size": 0,
			},
			"PowderComponent": {
				"max_uses": 5,
				"buff": BuffFactory.make_buff({
					"duration": 50,
					"buff_name": "Super cool Test Buff",
					"buff_sprite_path": "",
					"description": "test buff for test powder",
					"modifiers": ModifierFactory.make_batch_modifiers([
						{
							"target_stat": "damage_min",
							"target_component": GameData.ComponentKeys.MELEE_COMBAT,
							"operation": GameData.MODIFIER_OPERATION.ADD,
							"value": 20.0,
							"conditions": [
								ConditionFactory.make_weapon_type_condition(GameData.WEAPON_TYPES.POLEARMS)
							]
						},
						{
							"target_stat": "damage_min",
							"target_component": GameData.ComponentKeys.MELEE_COMBAT,
							"operation": GameData.MODIFIER_OPERATION.MULTIPLY,
							"value": 1.7,
						},
						{
							"target_stat": "element",
							"target_component": GameData.ComponentKeys.MELEE_COMBAT,
							"operation": GameData.MODIFIER_OPERATION.OVERRIDE,
							"value": GameData.ELEMENT.FIRE,
						},
					]),
				}),
			}
		},
	},

	# ====================
	# MONSTER PARTS
	# ====================

	ITEMS.PILE_OF_ASH: {
		"base_data": {
			"id": ITEMS.PILE_OF_ASH,
			"uid": ITEMS.keys()[ITEMS.PILE_OF_ASH],
			"display_name": "PILE_OF_ASH",
			"description": "A PILE_OF_ASH",
			"item_type": GameData.ITEM_TYPES.MONSTER_PART,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 8,
		},

		"components": {
			"StackableComponent": {
				"is_stackable": true,
				"max_stack_size": 33
			}
		}
	},

	ITEMS.IRON_STRING_HEART: {
		"base_data": {
			"id": ITEMS.IRON_STRING_HEART,
			"uid": ITEMS.keys()[ITEMS.IRON_STRING_HEART],
			"display_name": "IRON_STRING_HEART",
			"description": "A IRON_STRING_HEART",
			"item_type": GameData.ITEM_TYPES.MONSTER_PART,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 12,
		},

		"components": {
			"StackableComponent": {
				"is_stackable": true,
				"max_stack_size": 33
			}
		}
	},

	ITEMS.INSECT_WINGS: {
		"base_data": {
			"id": ITEMS.INSECT_WINGS,
			"uid": ITEMS.keys()[ITEMS.INSECT_WINGS],
			"display_name": "INSECT_WINGS",
			"description": "A INSECT_WINGS",
			"item_type": GameData.ITEM_TYPES.MONSTER_PART,
			"sprite_path": "",
			"rarity": GameData.RARITY.COMMON,
			"value": 9,
		},

		"components": {
			"StackableComponent": {
				"is_stackable": true,
				"max_stack_size": 33
			}
		}
	},

	# ====================
	# RESOURCES
	# ====================

	ITEMS.IRON_LUMP: {
		"base_data": {
			"id": ITEMS.IRON_LUMP,
			"uid": ITEMS.keys()[ITEMS.IRON_LUMP],
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

	# IRON_BATTLEAXE,
	# STEEL_BATTLEAXE,

	IRON_POLEAXE,

	STEEL_DAGGER,


	# --- SHIELDS ---
	ROUND_SHIELD,
	# KITE_SHIELD,

	# --- ARMOR ---
	
	# Chest
	IRON_CHESTPLATE,
	# STEEL_CHESTPLATE,

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
	# GAMBESON,

	# --- POWDER ---
	TEST_POWDER,
	SUPER_COOL_POWDER,


	# --- MONSTER PARTS ---

	INSECT_WINGS,
	IRON_STRING_HEART,
	PILE_OF_ASH,


	# --- RESOURCE ---
	IRON_LUMP,
}
