class_name LootOnGroundRenderer
extends Node


var loot_positions: Dictionary = {}
# {grid_pos: Sprite2D}

func _init() -> void:
    SignalBus.item_dropped.connect(_on_item_dropped)
    SignalBus.all_items_picked_up.connect(_on_all_items_picked_up)

func _on_item_dropped(_item: ItemResource, grid_pos: Vector2i) -> void:

    # already rendered at pos
    if grid_pos in loot_positions.keys():
        return

    var loot_sprite := Sprite2D.new()
    loot_sprite.z_as_relative = false
    loot_sprite.z_index = GameData.LOOT_Z_INDEX
    loot_sprite.texture = load(DirectoryPaths.loot_on_ground_sprite)
    loot_sprite.position = MapFunction.to_world_pos(grid_pos)
    GameData.main_node.add_child(loot_sprite)

    loot_positions[grid_pos] = loot_sprite

func _on_all_items_picked_up(grid_pos: Vector2i) -> void:
    loot_positions[grid_pos].queue_free()
    loot_positions.erase(grid_pos)

func remove_all_sprites() -> void:
    for sprite in loot_positions.values():
        sprite.queue_free()
    loot_positions.clear()