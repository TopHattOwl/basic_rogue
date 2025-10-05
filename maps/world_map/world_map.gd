extends Node2D



func _ready() -> void:
	if GameData.dungeon_draw_debug:
		var dungeon_layer: TileMapLayer = $Dungeons
		for dungeon in WorldMapData.dungeons.dungeons:
			var grid = dungeon.world_map_pos
			dungeon_layer.set_cell(Vector2i(grid.x, grid.y), 0, Vector2i(0, 0))