class_name WorldMonsterTile
extends Resource

# @export var monster_tier: int
# @export var monster_types: Array
@export var has_dungeon: bool
@export var dungeon_pos: Vector2i # dungeon are several tiles big, top left position is dungeon pos
@export var world_map_pos: Vector2i

var dungeon

func _init(_world_pos: Vector2i = Vector2i.ZERO) -> void:
	has_dungeon = false # filled in when generating world tile
	world_map_pos = _world_pos

# called when entering not explored map so it gets generated
func add_dungeon_tile(pos: Vector2i) -> void:
	has_dungeon = true
	dungeon_pos = pos

	var biome_type = WorldMapData.biome_map.map_data[world_map_pos.y][world_map_pos.x].biome_type
	if biome_type == null:
		push_error("biome type is null at world map pos: ", world_map_pos)
		return
	match biome_type:
		GameData.WORLD_TILE_TYPES.FIELD:
			dungeon = FieldDungeon.new()
		GameData.WORLD_TILE_TYPES.DESERT:
			print("DESERT dungeon")
		GameData.WORLD_TILE_TYPES.SWAMP:
			print("SWAMP dungeon")
		GameData.WORLD_TILE_TYPES.MOUNTAIN:
			print("MOUNTAIN dungeon")
		GameData.WORLD_TILE_TYPES.FOREST:
			print("FOREST dungeon")

	dungeon.make_dungeon(world_map_pos)