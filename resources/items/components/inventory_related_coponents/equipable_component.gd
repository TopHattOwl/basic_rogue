class_name EquipableComponent
extends ItemComponent

var equipped: bool
@export var equipment_slot: int # from enum EQUIPMENT_SLOTS



func _equip_item(_item: ItemResource, entity: Node2D) -> void:
    if ComponentRegistry.get_component(entity, GameData.ComponentKeys.EQUIPMENT).equip_item(_item, equipment_slot):
        equipped = true
    
