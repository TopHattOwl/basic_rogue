class_name ItemComponent
extends Resource

func on_add_to_inventory(_item: ItemResource, _entity: Node2D = null) -> void:
    pass
    
func on_equip(_item: ItemResource, _entity: Node2D) -> void:
    pass

func on_unequip(_item: ItemResource, _entity: Node2D) -> void:
    pass

func om_use(_item: ItemResource, _entity: Node2D, _target: Variant = null) -> void:
    pass