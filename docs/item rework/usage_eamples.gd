# # ====================
# # BASIC USAGE EXAMPLES
# # ====================

# # Create a basic item
# var rusty_sword = ItemFactory.create_item(GameData.ITEMS.RUSTY_SWORD)
# GameData.player.InventoryComp.add_item(rusty_sword)

# # Create a stackable item with count
# var health_potions = ItemFactory.create_item(GameData.ITEMS.HEALTH_POTION, 5)
# GameData.player.InventoryComp.add_item(health_potions)

# # Create an enchanted weapon
# var flame_sword_data = {
# 	"prefix": "Flaming",
# 	"new_rarity": GameData.RARITY.RARE,
# 	"damage_bonus_min": 5,
# 	"damage_bonus_max": 10,
# 	"additional_bonuses": [
# 		{
# 			"stat": GameData.STATS.FIRE_DAMAGE,
# 			"value": 15,
# 			"type": GameData.MODIFIER_TYPE.FLAT,
# 		}
# 	],
# 	"rune_sockets": 2,
# }
# var flame_sword = ItemFactory.create_enchanted_weapon(GameData.ITEMS.RUSTY_SWORD, flame_sword_data)


# # ====================
# # RUNE SYSTEM EXAMPLE
# # ====================

# # First, define runes in ItemDefinitions
# # Add to item_definitions.gd:
# """
# GameData.ITEMS.RUNE_OF_STRENGTH: {
# 	"base_data": {
# 		"uid": "rune_of_strength",
# 		"display_name": "Rune of Strength",
# 		"description": "A mystical rune that enhances physical power.",
# 		"item_type": GameData.ITEM_TYPES.RUNE,
# 		"sprite_path": "res://assets/items/runes/strength_rune.png",
# 		"rarity": GameData.RARITY.RARE,
# 		"value": 100,
# 	},
# 	"components": {
# 		"RuneEffectComponent": {
# 			"stat_bonuses": [
# 				{
# 					"stat": GameData.STATS.STRENGTH,
# 					"value": 5,
# 					"type": GameData.MODIFIER_TYPE.FLAT,
# 				},
# 				{
# 					"stat": GameData.STATS.DAMAGE,
# 					"value": 0.1,
# 					"type": GameData.MODIFIER_TYPE.PERCENTAGE,
# 				}
# 			],
# 		},
# 	},
# },
# """

# # Create a weapon with sockets
# var weapon_with_sockets = ItemFactory.create_modified_item(
# 	GameData.ITEMS.IRON_BATTLEAXE,
# 	{
# 		"components": {
# 			"RuneSocketComponent": {
# 				"max_sockets": 3,
# 			}
# 		}
# 	}
# )

# # Create a rune
# var strength_rune = ItemFactory.create_item(GameData.ITEMS.RUNE_OF_STRENGTH)

# # Socket the rune into the weapon
# var socket_comp = weapon_with_sockets.get_component(RuneSocketComponent)
# if socket_comp and socket_comp.has_empty_socket():
# 	if socket_comp.socket_rune(strength_rune):
# 		print("Rune socketed successfully!")


# # ====================
# # ITEM ENHANCEMENT SYSTEM
# # ====================

# class_name ItemEnhancer
# extends Node

# # Enhance an item by adding random bonuses
# static func enhance_item(item: ItemResource, enhancement_level: int) -> void:
# 	var weapon_comp = item.get_component(MeleeWeaponComponent)
# 	if not weapon_comp:
# 		return
	
# 	# Add bonus damage based on enhancement level
# 	weapon_comp.damage_min += enhancement_level * 2
# 	weapon_comp.damage_max += enhancement_level * 3
	
# 	# Maybe add a random bonus
# 	if randf() > 0.5:
# 		var random_bonus = _get_random_bonus(enhancement_level)
# 		weapon_comp.bonuses.append(random_bonus)
	
# 	# Update item display name
# 	item.display_name = "+" + str(enhancement_level) + " " + item.display_name

# static func _get_random_bonus(level: int) -> StatModifier:
# 	var bonus = StatModifier.new()
	
# 	var possible_stats = [
# 		GameData.STATS.STRENGTH,
# 		GameData.STATS.DEXTERITY,
# 		GameData.STATS.CRITICAL_CHANCE,
# 		GameData.STATS.ATTACK_SPEED,
# 	]
	
# 	bonus.stat = possible_stats[randi() % possible_stats.size()]
# 	bonus.value = level + randi() % (level + 1)
# 	bonus.modifier_type = GameData.MODIFIER_TYPE.FLAT
	
# 	return bonus


# # ====================
# # PROCEDURAL ITEM GENERATION
# # ====================

# class_name LootGenerator
# extends Node

# # Generate a random item based on level and rarity
# static func generate_random_item(area_level: int, forced_rarity: int = -1) -> ItemResource:
# 	var rarity = forced_rarity if forced_rarity >= 0 else _determine_rarity()
	
# 	# Get base item
# 	var item_pool = ItemDefinitions.get_items_by_type(GameData.ITEM_TYPES.WEAPON)
# 	var base_item_id = item_pool.keys()[randi() % item_pool.size()]
	
# 	# Create modifications based on area level and rarity
# 	var modifications = _generate_modifications(area_level, rarity)
	
# 	var item = ItemFactory.create_modified_item(base_item_id, modifications)
	
# 	return item

# static func _determine_rarity() -> int:
# 	var roll = randf()
# 	if roll < 0.6:
# 		return GameData.RARITY.COMMON
# 	elif roll < 0.85:
# 		return GameData.RARITY.UNCOMMON
# 	elif roll < 0.95:
# 		return GameData.RARITY.RARE
# 	else:
# 		return GameData.RARITY.LEGENDARY

# static func _generate_modifications(area_level: int, rarity: int) -> Dictionary:
# 	var mods = {
# 		"base_data": {
# 			"rarity": rarity,
# 		},
# 		"components": {
# 			"MeleeWeaponComponent": {
# 				"damage_min": area_level / 2,
# 				"damage_max": area_level,
# 				"bonuses": _generate_random_bonuses(rarity),
# 			}
# 		}
# 	}
	
# 	# Add sockets for rare+ items
# 	if rarity >= GameData.RARITY.RARE:
# 		mods["components"]["RuneSocketComponent"] = {
# 			"max_sockets": 1 + (rarity - GameData.RARITY.RARE),
# 		}
	
# 	return mods

# static func _generate_random_bonuses(rarity: int) -> Array:
# 	var bonuses = []
# 	var num_bonuses = rarity + 1 # More bonuses for higher rarity
	
# 	for i in range(num_bonuses):
# 		bonuses.append({
# 			"stat": randi() % 10, # Random stat
# 			"value": randi() % 10 + 1,
# 			"type": GameData.MODIFIER_TYPE.FLAT,
# 		})
	
# 	return bonuses


# # ====================
# # SAVING/LOADING ITEMS
# # ====================

# class_name ItemSerializer
# extends Node

# # Serialize item to dictionary for saving
# static func serialize_item(item: ItemResource) -> Dictionary:
# 	var data = {
# 		"uid": item.uid,
# 		"display_name": item.display_name,
# 		"description": item.description,
# 		"item_type": item.item_type,
# 		"components": [],
# 	}
	
# 	for component in item.components:
# 		data["components"].append(_serialize_component(component))