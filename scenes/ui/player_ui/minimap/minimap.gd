extends Control
# handles minimap
# upadtes with player position

@export var tilemap: TileMapLayer

var player_world_pos: Vector2i

var x: int = 15
var y: int = 7

var player_tile_x: int = 8
var player_tile_y: int = 4

# holds tile poitions around the player
# key is the tilemap position, value is world_map position of the tile
var adjacent_positions: Dictionary

func _ready() -> void:
	player_world_pos = GameData.player.get_component(GameData.ComponentKeys.PLAYER).world_map_pos
	SignalBus.world_map_pos_changed.connect(_on_world_map_pos_changed)
	adjacent_positions = get_adjacent_positions()
	draw_minimap()

func _on_world_map_pos_changed(new_pos: Vector2i, _old_pos: Vector2i) -> void:
	player_world_pos = new_pos
	adjacent_positions = get_adjacent_positions()
	draw_minimap()


func draw_minimap() -> void:
	for tile in adjacent_positions.keys():
		var biome_type: int = WorldMapData.get_biome_type(adjacent_positions[tile])
		if biome_type not in tile_draw_data.keys():
			biome_type = -1
		tilemap.set_cell(tile, 0, tile_draw_data[biome_type].atlas)
		


func get_adjacent_positions() -> Dictionary:
	var _tiles: Dictionary = {}

	var x_first = player_world_pos.x - x + player_tile_x
	var y_first = player_world_pos.y - y + player_tile_y
	
	# i and j will be the tilemap's grid positon
	# _x and _y will be the world map's grid position
	var i = 0
	var j = 0
	for _x in range(x):
		j = 0
		for _y in range(y):
			if _x < 0 or _y < 0 or _x >= GameData.WORLD_MAP_SIZE.x or _y >= GameData.WORLD_MAP_SIZE.y:
				continue
			_tiles[Vector2i(i, j)] = (Vector2i(x_first + _x, y_first + _y))
			j += 1
		i += 1

	return _tiles



var tile_draw_data: Dictionary = {
	GameData.WORLD_TILE_TYPES.FIELD: {
		"atlas": Vector2i(0, 0),
	},
	GameData.WORLD_TILE_TYPES.FOREST: {
		"atlas": Vector2i(1, 0),
	},
	GameData.WORLD_TILE_TYPES.MOUNTAIN: {
		"atlas": Vector2i(2, 0),
	},
	GameData.WORLD_TILE_TYPES.DESERT: {
		"atlas": Vector2i(3, 0),
	},
	GameData.WORLD_TILE_TYPES.WATER: {
		"atlas": Vector2i(4, 0),
	},
	-1: { # placeholder for not implemented stuff
		"atlas": Vector2i(5, 5),
	}
}
