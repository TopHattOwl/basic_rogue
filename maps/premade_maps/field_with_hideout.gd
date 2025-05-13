extends Node2D


func _ready() -> void:
    EntitySystems.entity_spawner.spawn_monster(Vector2i(20, 6), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(19, 5), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(18, 5), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(17, 6), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(16, 5), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(21, 4), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(22, 4), GameData.MONSTERS1.GIANT_WORM)
    EntitySystems.entity_spawner.spawn_monster(Vector2i(16, 6), GameData.MONSTERS1.GIANT_WORM)
