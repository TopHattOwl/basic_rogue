class_name EquipmentComponent
extends Node



var weapon: Dictionary = {}
var shield: Dictionary = {}
var ranged_weapon: Dictionary = {}
var armor: Dictionary = {
	GameData.ARMOR_SLOTS.HEAD: null,
	GameData.ARMOR_SLOTS.SHOULDERS: null,
	GameData.ARMOR_SLOTS.CHEST: null,
	GameData.ARMOR_SLOTS.ARMS: null,
	GameData.ARMOR_SLOTS.HANDS: null,
	GameData.ARMOR_SLOTS.LEGS: null,
	GameData.ARMOR_SLOTS.FEET: null
}

func get_total_armor() -> int:
	var total_armor = 0
	for armor_slot in armor:
		if armor[armor_slot] != null:
			total_armor += armor[armor_slot].armor
	return total_armor

func get_weapn_stats() -> Dictionary:
	if weapon != null:
		return weapon.full_stats
	return {}
