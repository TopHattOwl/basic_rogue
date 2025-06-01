class_name InventoryComponent
extends Node

var weapons: Array = []
var reanged_weapons: Array = []
var armor: Array = []
var potions: Array = []
var poweders: Array = []
var monster_parts: Array = []
var resources: Array = []
var others: Array = []


func initialize(d: Dictionary) -> void:
	weapons = d.get("weapons", [])
	reanged_weapons = d.get("reanged_weapons", [])
	armor = d.get("armor", [])
	potions = d.get("potions", [])
	poweders = d.get("poweders", [])
	monster_parts = d.get("monster_parts", [])
	resources = d.get("resources", [])
	others = d.get("others", [])

# func add_item_to_inventory(item: Node2D) -> void:
# 	print("item added")
	
# 	match ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_IDENTITY).item_type:
# 		GameData.ITEM_TYPES.WEAPON:
# 			weapons.append(item)
# 		GameData.ITEM_TYPES.ARMOR:
# 			armor.append(item)
# 		GameData.ITEM_TYPES.POTION:
# 			potions.append(item)
# 		GameData.ITEM_TYPES.POWDER:
# 			poweders.append(item)
# 		GameData.ITEM_TYPES.MONSTER_PART:
# 			monster_parts.append(item)
# 		GameData.ITEM_TYPES.RESOURCE:
# 			resources.append(item)
# 		GameData.ITEM_TYPES.OTHER:
# 			others.append(item)


# func remove_item_from_inventory(item: Node2D) -> void:
# 	match ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_IDENTITY).item_type:
# 		GameData.ITEM_TYPES.WEAPON:
# 			weapons.erase(item)
# 		GameData.ITEM_TYPES.ARMOR:
# 			armor.erase(item)
# 		GameData.ITEM_TYPES.POTION:
# 			potions.erase(item)
# 		GameData.ITEM_TYPES.POWDER:
# 			poweders.erase(item)
# 		GameData.ITEM_TYPES.MONSTER_PART:
# 			monster_parts.erase(item)
# 		GameData.ITEM_TYPES.RESOURCE:
# 			resources.erase(item)
# 		GameData.ITEM_TYPES.OTHER:
# 			others.erase(item)
