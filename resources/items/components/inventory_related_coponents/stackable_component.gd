class_name StackableComponent
extends ItemComponent

@export var is_stackable: bool = false

@export var max_stack_size: int = 0

@export var count: int = 1

func on_add_to_inventory(_item: ItemResource, _entity: Node2D = null) -> void:
    pass