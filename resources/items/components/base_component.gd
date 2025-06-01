class_name ItemComponent
extends Resource

func on_add_to_inventory(_item: ItemResource, _inventory: InventoryComponent, entity: Node2D = null) -> void:
    # if no entity is given default to player
    if !entity:
        entity = GameData.player
    