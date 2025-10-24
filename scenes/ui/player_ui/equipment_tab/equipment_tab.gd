class_name EquipmentTabControlNode
extends Control


@onready var equipment_slots: Array[EquipmentSlotControlNode]



func _ready() -> void:
	for child in get_children():
		if child is EquipmentSlotControlNode:
			equipment_slots.append(child)


func scan_items() -> void:
	for slot in equipment_slots:
		slot.fill_in_equipment()
