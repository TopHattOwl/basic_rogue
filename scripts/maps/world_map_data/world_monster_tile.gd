class_name WorldMonsterTile
extends Resource

@export var monster_tier: int
@export var monster_types: Array
@export var spawn_points: Array
@export var has_dungeon: bool
@export var grid_pos: Vector2i

func _init(pos: Vector2i, tier: int) -> void:
	monster_tier = calc_monster_tier(pos)
	monster_types = get_monster_types(pos, tier)
	spawn_points = [] # filled when map is generated
	has_dungeon = false # same
	grid_pos = pos

func calc_monster_tier(pos: Vector2i) -> int:
	var savagery = WorldMapData.world_map_savagery[pos.y][pos.x]
	
	var tier = savagery / 3
	tier = tier if tier > 0 else 1

	return tier

func get_monster_types(pos: Vector2i, tier: int) -> Array:
	var biome = WorldMapData.biome_type[pos.y][pos.x]

	# if biome type does not upport monster spawning -> skip
	if !GameData.MonstersAll[tier].has(biome):
		return []
	
	var types = GameData.MonstersAll[tier][WorldMapData.biome_type[pos.y][pos.x]]
	return types
