class_name EquipmentComponent
extends Node

var equipment = {
	GameData.EQUIPMENT_SLOTS.MAIN_HAND: null,
	GameData.EQUIPMENT_SLOTS.OFF_HAND: null,
	GameData.EQUIPMENT_SLOTS.HEAD: null,
	GameData.EQUIPMENT_SLOTS.SHOULDERS: null,
	GameData.EQUIPMENT_SLOTS.CHEST: null,
	GameData.EQUIPMENT_SLOTS.ARMS: null,
	GameData.EQUIPMENT_SLOTS.HANDS: null,
	GameData.EQUIPMENT_SLOTS.LEGS: null,
	GameData.EQUIPMENT_SLOTS.FEET: null,
	GameData.EQUIPMENT_SLOTS.BELT: null,
	GameData.EQUIPMENT_SLOTS.NECK: null,
	GameData.EQUIPMENT_SLOTS.HEAD_UNDER: null,
	GameData.EQUIPMENT_SLOTS.CHEST_UNDER: null,
	GameData.EQUIPMENT_SLOTS.LEGS_UNDER: null,
}

func _ready() -> void:

	# --- not sure if this is needed, prolly not ---
	# if get_parent().get_parent().is_in_group("player"):
	# 	SignalBus.equipment_changing.connect(equip_item)

	pass

func equip_item(item: ItemResource, slot: int) -> bool:

	print("[EquipmentComponent] trying to equip item")
	if not _can_equip_item(item, slot):
		return false
	
	unequip_item(slot)

	# handle two handed case
	handle_two_handed(item, slot)

	# equip the item
	equipment[slot] = item
	item._call_component_method({
		"method_name": "on_equip",
		"entity": get_parent().get_parent(),
	})
	
	if get_parent().has_node(GameData.get_component_name(GameData.ComponentKeys.PLAYER)):	
		SignalBus.equipment_changed.emit({
				"slot": slot,
				"item": item
			})
	
	# remove item from inventory
	var inventory: InventoryComponent = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.INVENTORY))
	inventory.remove_item(item)

	print("[EquipmentComponent] equipped item")
	return true
	

func unequip_item(slot: int) -> void:
	var item = equipment[slot]
	if not item:
		return

	item._call_component_method({
		"method_name": "on_unequip",
		"entity": get_parent().get_parent(),
	})

	# add item to inventory
	var inventory: InventoryComponent = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.INVENTORY))
	inventory.add_item(item)

	equipment[slot] = null
	SignalBus.equipment_changed.emit({
			"slot": slot,
			"item": null
		})


func handle_two_handed(_item: ItemResource, _slot: int) -> void:
	var two_handed_types = [
		GameData.WEAPON_SUBTYPES.AXE_2H,
		GameData.WEAPON_SUBTYPES.SWORD_2H,
		GameData.WEAPON_SUBTYPES.MACE_2H,
		GameData.WEAPON_SUBTYPES.SPEAR_2H,
		GameData.WEAPON_SUBTYPES.POLEARM_2H,
	]
	var item_melee_comp: MeleeWeaponComponent = _item.get_component(MeleeWeaponComponent)

	# if item is for main hand and two handed
	if _slot == GameData.EQUIPMENT_SLOTS.MAIN_HAND && item_melee_comp.weapon_sub_type in two_handed_types:
		unequip_item(GameData.EQUIPMENT_SLOTS.OFF_HAND)
		return

	# if item is for off hand and two handed weapon is in main hand
	var main_hand_item: ItemResource = equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND]
	if not main_hand_item:
		return

	var main_hand_slot: int = main_hand_item.get_component(MeleeWeaponComponent).weapon_sub_type
	if _slot == GameData.EQUIPMENT_SLOTS.OFF_HAND && main_hand_slot in two_handed_types:
		unequip_item(GameData.EQUIPMENT_SLOTS.MAIN_HAND)
		return

func _can_equip_item(_item: ItemResource, _slot: int) -> bool:

	return true
