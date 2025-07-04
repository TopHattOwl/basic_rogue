class_name WorldMonsterTile
extends Resource

@export var monster_tier: int
@export var monster_types: Array
# @export var spawn_points: Array
@export var has_dungeon: bool
@export var dungeon_pos: Vector2i # dungeon are several tiles big, top left position is dungeon pos
@export var world_map_pos: Vector2i

var dungeon

func _init(_world_pos: Vector2i = Vector2i.ZERO, tier: int = 1) -> void:
	monster_tier = tier
	monster_types = get_monster_types(_world_pos, tier)
	# spawn_points = [] # filled when map is generated
	has_dungeon = false # same
	world_map_pos = _world_pos

func calc_monster_tier(pos: Vector2i) -> int:
	var savagery = WorldMapData.world_map_savagery[pos.y][pos.x]
	
	var tier = savagery / 3
	tier = tier if tier > 0 else 1

	return clampi(tier, 1, 5)

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

func get_monster_types(pos: Vector2i, tier: int) -> Array:
	var biome = WorldMapData.biome_type[pos.y][pos.x]

	# if biome type does not upport monster spawning -> skip
	if !GameData.MonstersAll[tier].has(biome):
		return []
	
	var types = GameData.MonstersAll[tier][WorldMapData.biome_type[pos.y][pos.x]]
	return types
