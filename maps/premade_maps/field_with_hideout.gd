extends Node2D


func _ready() -> void:
    EntitySpawner.spawn_monster(Vector2i(20, 6), GameData.MONSTERS_ALL.MASK)
    EntitySpawner.spawn_monster(Vector2i(19, 5), GameData.MONSTERS_ALL.MASK)
    EntitySpawner.spawn_monster(Vector2i(18, 5), GameData.MONSTERS_ALL.IRON_WORM)
    EntitySpawner.spawn_monster(Vector2i(17, 6), GameData.MONSTERS_ALL.MASK)
    EntitySpawner.spawn_monster(Vector2i(16, 5), GameData.MONSTERS_ALL.IRON_WORM)
    EntitySpawner.spawn_monster(Vector2i(21, 4), GameData.MONSTERS_ALL.IRON_WORM)

