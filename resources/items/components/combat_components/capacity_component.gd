class_name CapacityComponent
extends ItemComponent

@export var max_capacity: int
var current_capacity: int


func use_capacity(amount: int) -> bool:
    if current_capacity < amount:
        return false

    current_capacity -= amount
    return true

func on_equip(_item: ItemResource, _entity: Node2D) -> void:
    current_capacity = max_capacity