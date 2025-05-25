extends Node2D



func _ready():

    EntitySpawner.spawn_item(Vector2i(6,6), GameData.ALL_ITEMS.STEEL_LONGSWORD)

    # spawn wizard here and and load it's data from json
    pass
