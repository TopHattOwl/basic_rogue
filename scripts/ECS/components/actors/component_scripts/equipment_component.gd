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
}

# not implemented yet
func get_total_armor() -> int:
	return 0


func equip_item(item: ItemResource, slot: int) -> bool:
	if not _can_equip_item(item, slot):
		return false
	
	unequip_item(slot)
	equipment[slot] = item
	_call_component_method(item, "on_equip", get_parent().get_parent())
	
	if get_parent().has_node(GameData.get_component_name(GameData.ComponentKeys.PLAYER)):	
		SignalBus.equipment_changed.emit({
				"slot": slot,
				"item": null
			})
	
	return true
	

func unequip_item(slot: int) -> void:
	var item = equipment[slot]
	if not item:
		return

	_call_component_method(item, "on_unequip", get_parent().get_parent())
	equipment[slot] = null
	SignalBus.equipment_changed.emit({
			"slot": slot,
			"item": null
		})

func _call_component_method(item: ItemResource, method_name: String, entity: Node2D = null) -> void:
	for comp in item.components:
		if comp.has_method(method_name):
			comp.call(method_name, item, entity)

func _can_equip_item(item: ItemResource, slot: int) -> bool:
	return true