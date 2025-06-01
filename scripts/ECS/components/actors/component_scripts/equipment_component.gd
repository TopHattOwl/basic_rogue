class_name EquipmentComponent
extends Node


var weapon: Node2D = null
var weapon2: Node2D = null


var main_hand: ItemResource = null
var off_hand: ItemResource = null
var ranged_weapon: ItemResource = null
var armor: Dictionary = {
	GameData.ARMOR_SLOTS.HEAD: ItemResource,
	GameData.ARMOR_SLOTS.SHOULDERS: ItemResource,
	GameData.ARMOR_SLOTS.CHEST: ItemResource,
	GameData.ARMOR_SLOTS.ARMS: ItemResource,
	GameData.ARMOR_SLOTS.HANDS: ItemResource,
	GameData.ARMOR_SLOTS.LEGS: ItemResource,
	GameData.ARMOR_SLOTS.FEET: ItemResource
}

func get_total_armor() -> int:
	return 0
	# var total_armor = 0
	# for armor_slot in armor:
	# 	if armor[armor_slot] != null:
	# 		total_armor += armor[armor_slot].armor
	# return total_armor


## equips the weeapon and updates melee combat
func equip_weapon(new_weapon: Node2D):
	# if weapon equipped, add to inventory
	if weapon:
		ComponentRegistry.get_component(get_parent().get_parent(), GameData.ComponentKeys.INVENTORY).weapons.append(weapon)
	weapon = new_weapon
	get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MELEE_COMBAT)).update()

	# TODO put eqipped weapon into inventory


func equip_main_hand(item: ItemResource) -> void:
	main_hand = item

	var item_melee_comp = item.get_component(MeleeWeaponComponent)

	# update melee combat component

	var melee_combat = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MELEE_COMBAT))
	if !melee_combat:
		push_error("no melee combat component")
		return

	melee_combat.damage_min = item_melee_comp.damage_min
	melee_combat.damage_max = item_melee_comp.damage_max
	melee_combat.attack_type = item_melee_comp.attack_type
	melee_combat.element = item_melee_comp.element
