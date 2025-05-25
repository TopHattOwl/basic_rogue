class_name EquipmentComponent
extends Node


var weapon: Node2D = null
var weapon2: Node2D = null
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


## equips the weeapon and updates melee combat
func equip_weapon(new_weapon: Node2D):
	# if weapon equipped, add to inventory
	if weapon:
		ComponentRegistry.get_component(get_parent().get_parent(), GameData.ComponentKeys.INVENTORY).weapons.append(weapon)
	weapon = new_weapon
	get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MELEE_COMBAT)).update()

	# TODO put eqipped weapon into inventory

