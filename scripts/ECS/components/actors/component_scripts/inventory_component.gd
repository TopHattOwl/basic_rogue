class_name InventoryComponent
extends Node

var inventory: Dictionary = {
	GameData.ITEM_TYPES.WEAPON: [],
	GameData.ITEM_TYPES.RANGED_WEAPON: [],
	GameData.ITEM_TYPES.SHIELD: [],
	GameData.ITEM_TYPES.ARMOR: [],
	GameData.ITEM_TYPES.POTION: [],
	GameData.ITEM_TYPES.POWDER: [],
	GameData.ITEM_TYPES.MONSTER_PART: [],
	GameData.ITEM_TYPES.ALCHEMY: [],
	GameData.ITEM_TYPES.RESOURCE: [],
	GameData.ITEM_TYPES.OTHER: []
}


func initialize(d: Dictionary) -> void:
	pass
