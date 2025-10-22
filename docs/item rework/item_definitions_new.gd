# # item_definitions.gd (Autoload Singleton)
# extends Node

# enum ITEM_CATEGORY { WEAPON, ARMOR, CONSUMABLE, MISC, QUEST }

# # Central item registry - all items defined here
# var item_definitions: Dictionary = {
# 	# ====================
# 	# WEAPONS
# 	# ====================
# 	GameData.ITEMS.RUSTY_SWORD: {
# 		"base_data": {
# 			"uid": "rusty_sword",
# 			"display_name": "Rusty Sword",
# 			"description": "An old blade, weathered but still sharp enough to draw blood.",
# 			"item_type": GameData.ITEM_TYPES.WEAPON,
# 			"sprite_path": "res://assets/items/weapons/rusty_sword.png",
# 			"rarity": GameData.RARITY.COMMON,
# 			"value": 15,
# 		},
# 		"components": {
# 			"EquipableComponent": {
# 				"equipment_slot": GameData.EQUIPMENT_SLOTS.MAIN_HAND,
# 			},
# 			"MeleeWeaponComponent": {
# 				"damage_min": 3,
# 				"damage_max": 8,
# 				"weapon_type": GameData.WEAPON_TYPES.SWORD,
# 				"weapon_sub_type": -1,
# 				"attack_type": GameData.ATTACK_TYPE.SLASH,
# 				"element": GameData.ELEMENT.PHYSICAL,
# 				"bonuses": [
# 					# Stat modifiers can be added here
# 				],
# 			},
# 		},
# 	},
	
# 	GameData.ITEMS.IRON_BATTLEAXE: {
# 		"base_data": {
# 			"uid": "iron_battleaxe",
# 			"display_name": "Iron Battleaxe",
# 			"description": "A heavy axe forged from solid iron. Devastating against unarmored foes.",
# 			"item_type": GameData.ITEM_TYPES.WEAPON,
# 			"sprite_path": "res://assets/items/weapons/iron_battleaxe.png",
# 			"rarity": GameData.RARITY.UNCOMMON,
# 			"value": 45,
# 		},
# 		"components": {
# 			"EquipableComponent": {
# 				"equipment_slot": GameData.EQUIPMENT_SLOTS.MAIN_HAND,
# 			},
# 			"MeleeWeaponComponent": {
# 				"damage_min": 8,
# 				"damage_max": 15,
# 				"weapon_type": GameData.WEAPON_TYPES.AXE,
# 				"weapon_sub_type": -1,
# 				"attack_type": GameData.ATTACK_TYPE.SLASH,
# 				"element": GameData.ELEMENT.PHYSICAL,
# 				"bonuses": [
# 					{
# 						"stat": GameData.STATS.STRENGTH,
# 						"value": 2,
# 						"type": GameData.MODIFIER_TYPE.FLAT,
# 					}
# 				],
# 			},
# 		},
# 	},
	
# 	# ====================
# 	# ARMOR
# 	# ====================
# 	GameData.ITEMS.LEATHER_ARMOR: {
# 		"base_data": {
# 			"uid": "leather_armor",
# 			"display_name": "Leather Armor",
# 			"description": "Simple but effective protection made from cured leather.",
# 			"item_type": GameData.ITEM_TYPES.ARMOR,
# 			"sprite_path": "res://assets/items/armor/leather_armor.png",
# 			"rarity": GameData.RARITY.COMMON,
# 			"value": 25,
# 		},
# 		"components": {
# 			"EquipableComponent": {
# 				"equipment_slot": GameData.EQUIPMENT_SLOTS.CHEST,
# 			},
# 			"ArmorComponent": {
# 				"armor_value": 8,
# 				"resistances": {
# 					GameData.ELEMENT.PHYSICAL: 0.1,
# 				},
# 				"bonuses": [],
# 			},
# 		},
# 	},
	
# 	# ====================
# 	# CONSUMABLES
# 	# ====================
# 	GameData.ITEMS.HEALTH_POTION: {
# 		"base_data": {
# 			"uid": "health_potion",
# 			"display_name": "Health Potion",
# 			"description": "A crimson elixir that restores vitality.",
# 			"item_type": GameData.ITEM_TYPES.CONSUMABLE,
# 			"sprite_path": "res://assets/items/consumables/health_potion.png",
# 			"rarity": GameData.RARITY.COMMON,
# 			"value": 20,
# 		},
# 		"components": {
# 			"StackableComponent": {
# 				"max_stack": 20,
# 				"count": 1,
# 			},
# 			"ConsumableComponent": {
# 				"use_type": GameData.CONSUMABLE_TYPE.INSTANT,
# 			},
# 			"HealingComponent": {
# 				"heal_amount": 50,
# 				"heal_type": GameData.HEAL_TYPE.HP,
# 			},
# 		},
# 	},
	
# 	# ====================
# 	# CONTAINERS
# 	# ====================
# 	GameData.ITEMS.QUIVER: {
# 		"base_data": {
# 			"uid": "quiver",
# 			"display_name": "Leather Quiver",
# 			"description": "Holds arrows for quick access in combat.",
# 			"item_type": GameData.ITEM_TYPES.CONTAINER,
# 			"sprite_path": "res://assets/items/containers/quiver.png",
# 			"rarity": GameData.RARITY.COMMON,
# 			"value": 10,
# 		},
# 		"components": {
# 			"EquipableComponent": {
# 				"equipment_slot": GameData.EQUIPMENT_SLOTS.AMMO_SLOT,
# 			},
# 			"CapacityComponent": {
# 				"max_capacity": 50,
# 			},
# 		},
# 	},
# }


# ## Get item definition by ID
# func get_item_definition(item_id: int) -> Dictionary:
# 	if not item_definitions.has(item_id):
# 		push_error("Item definition not found for ID: " + str(item_id))
# 		return {}
# 	return item_definitions[item_id]


# ## Get all items of a specific type
# func get_items_by_type(item_type: int) -> Dictionary:
# 	var filtered_items = {}
# 	for item_id in item_definitions:
# 		if item_definitions[item_id]["base_data"]["item_type"] == item_type:
# 			filtered_items[item_id] = item_definitions[item_id]
# 	return filtered_items


# ## Get all items of a specific rarity
# func get_items_by_rarity(rarity: int) -> Dictionary:
# 	var filtered_items = {}
# 	for item_id in item_definitions:
# 		if item_definitions[item_id]["base_data"].get("rarity", -1) == rarity:
# 			filtered_items[item_id] = item_definitions[item_id]
# 	return filtered_items