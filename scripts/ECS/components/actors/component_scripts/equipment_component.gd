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
	if get_parent().get_parent().is_in_group("player"):
		SignalBus.equipment_changing.connect(equip_item)


func equip_item(item: ItemResource, slot: int) -> bool:

	print("equiping item")
	if not _can_equip_item(item, slot):
		return false
	
	unequip_item(slot)
	equipment[slot] = item

	item._call_component_method({
		"method_name": "on_equip",
		"entity": get_parent().get_parent(),
	})
	
	if get_parent().has_node(GameData.get_component_name(GameData.ComponentKeys.PLAYER)):	
		SignalBus.equipment_changed.emit({
				"slot": slot,
				"item": null
			})
	
	# remove item from inventory
	var inventory = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.INVENTORY))
	inventory.remove_item(item)

	return true
	

func unequip_item(slot: int) -> void:
	var item = equipment[slot]
	if not item:
		return

	item._call_component_method({
		"method_name": "on_unequip",
		"entity": get_parent().get_parent(),
	})

	equipment[slot] = null
	SignalBus.equipment_changed.emit({
			"slot": slot,
			"item": null
		})


func _can_equip_item(_item: ItemResource, _slot: int) -> bool:
	return true
