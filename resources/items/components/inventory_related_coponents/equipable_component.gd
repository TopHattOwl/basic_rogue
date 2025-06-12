class_name EquipableComponent
extends ItemComponent

var equipped: bool
@export var equipment_slot: int # from enum EQUIPMENT_SLOTS


func on_equip(_item: ItemResource, _entity: Node2D) -> void:
    equipped = true

func on_unequip(_item: ItemResource, _entity: Node2D) -> void:
    equipped = false