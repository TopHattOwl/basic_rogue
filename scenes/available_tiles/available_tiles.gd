extends TileMapLayer

var avalible_tiles: Array[Vector2i]

const TERRAIN_SET: int = 0
const TERRAIN_ID: int = 0



func set_avalible_tiles(tiles: Array[Vector2i]) -> void:
    avalible_tiles = tiles

func _ready() -> void:
    # draw avalible tiles
    draw_terrain()


func draw_terrain() -> void:
    modulate = Color(1, 1, 1, 0.306275)
    if avalible_tiles.is_empty():
        return

    set_cells_terrain_connect(
        avalible_tiles,
        TERRAIN_SET,
        TERRAIN_ID,
        false
    )

