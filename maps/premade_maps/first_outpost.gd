extends Node2D



func _ready():

    EntitySpawner.spawn_item(Vector2i(6,6), GameData.ALL_ITEMS.STEEL_LONGSWORD)


    EntitySpawner.spawn_monster(Vector2i(10, 10), GameData.MONSTERS_ALL.IRON_WORM)
    EntitySpawner.spawn_monster(Vector2i(12, 11), GameData.MONSTERS_ALL.IRON_WORM)
    EntitySpawner.spawn_monster(Vector2i(13, 10), GameData.MONSTERS_ALL.IRON_WORM)
    EntitySpawner.spawn_monster(Vector2i(15, 14), GameData.MONSTERS_ALL.IRON_WORM)

    # spawn wizard here and and load it's data from json
    pass
