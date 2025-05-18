extends TileMapLayer


func _ready() -> void:
    var x = -20
    var y = -10

    while x < (GameData.MAP_SIZE.x + 20):
        while y < (GameData.MAP_SIZE.y + 10):
            self.set_cell(Vector2i(x, y), 3, Vector2i(0, 0))
            y += 1
        y = -10
        x += 1

func _process(_delta) -> void:
    if ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map:
        self.visible = false
    else:
        self.visible = true

