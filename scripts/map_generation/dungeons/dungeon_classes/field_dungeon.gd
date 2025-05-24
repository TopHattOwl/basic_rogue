class_name FieldDungeon
extends Resource

@export var name: String = "Field Dungeon"

@export var levels: Array = []
@export var boss_id: int 
@export var monster_types: Array
@export var world_map_pos: Vector2i

var rng = RandomNumberGenerator.new()

func make_dungeon(_world_pos: Vector2i) -> void:
	world_map_pos = _world_pos
	rng.seed = WorldMapData.world_map2.map_data[world_map_pos.y][world_map_pos.x].generated_seed

	monster_types = WorldMapData.world_monster_map.map_data[world_map_pos.y][world_map_pos.x].monster_types
	var monster_tier = WorldMapData.world_monster_map.map_data[world_map_pos.y][world_map_pos.x].monster_tier

	var dungeon_levels = rng.randi_range(3, 7)

	for level in dungeon_levels:
		levels.append(FieldDungeonLevel.new())
		levels[level].generate_dugeon_level(level, world_map_pos, monster_types, monster_tier)


func enter_dungeon() -> void:
	print("entering dungeon")
	print("world_pos: ", world_map_pos)
	print("dungeon_type: ", name)

	var _dungeon = load(DirectoryPaths.dungeon).instantiate()
	_dungeon.init_data(make_dungeon_node_data())
	GameData.current_dungeon = _dungeon

	if GameData.current_map:
		GameData.current_map.queue_free()
		GameData.current_map = null
	GameData.remove_entities(true)

	GameData.terrain_map = levels[0].terrain_map

	GameData.player.PlayerComp.is_in_dungeon = true
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.DUNGEON_INPUT
	GameData.main_node.add_child(GameData.current_dungeon)


	# set camera stuff
	UiFunc.update_camera_data()


func make_dungeon_node_data() -> Dictionary:
	return {
		"terrain_map": levels[0].terrain_map,
		"dungeon_level_size": levels[0].map_size,
		"tile_sets": tileset_resource,
		"tile_set_draw_data": tile_set_draw_data,
		"rng": rng
	}


var tileset_resource =  {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/dungeon_tile_sets/field_dungeon/field_floor_dungeon_tileset.tres",
		GameData.TILE_TAGS.STAIR: "res://resources/tiles/biome_sets/field/field_stair_tileset.tres",
		GameData.TILE_TAGS.DOOR: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.DOOR_FRAME: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.NATURE: "res://resources/tiles/biome_sets/field/field_nature_tileset.tres",
		GameData.TILE_TAGS.WALL: "res://resources/tiles/biome_sets/field/field_wall_tileset.tres",
	}

var tile_set_draw_data ={
	GameData.TILE_TAGS.FLOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 1), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.WALL: {
		"source_id": 1,
		"atlas_coords_max": Vector2i(0, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.STAIR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.DOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(0, 0),
		"atlas_coords_min": Vector2i(0, 0),
	},
	GameData.TILE_TAGS.DOOR_FRAME: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 0), 
		"atlas_coords_min": Vector2i(1, 0),
	},
	GameData.TILE_TAGS.NATURE: {
		"source_id": 2,
		"atlas_coords_max": Vector2i(0, 0), 
		"atlas_coords_min": Vector2i(1, 0),
	},
}
