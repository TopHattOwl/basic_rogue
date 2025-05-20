class_name FieldBiome
extends Resource

@export var biome_type: int
@export var biome_name: String
@export var grid_pos: Vector2i

var map_rng = RandomNumberGenerator.new()


# varaibles that gets filled when generating
@export var terrain_map: Array[Array]


# load data into world Node here and set variables

func _init(_pos: Vector2i = Vector2i.ZERO) -> void:
	pass

func setup(pos: Vector2i = Vector2i.ZERO) -> void:
	biome_type = GameData.WORLD_TILE_TYPES.FIELD
	biome_name = "Field"
	grid_pos = pos

# generation

func generate_map() -> void:
	map_rng.seed = WorldMapData.world_map2.map_data[grid_pos.y][grid_pos.x].generated_seed
	terrain_map = MapFunction.make_base_terrain_map()

	var savagery = WorldMapData.world_map_savagery[grid_pos.y][grid_pos.x]
	var monster_data = WorldMapData.world_map_monster_data[grid_pos.y][grid_pos.x]
	var biome_type = WorldMapData.biome_type[grid_pos.y][grid_pos.x]


	generate_terrain_data()

	var world_node_data = {
		"a": 1,
	}

func generate_terrain_data() -> void:
	add_walls()
	add_nature()
	# add_forage() # add when implemented foliage
	add_monsters()

# generation helpers

func add_walls() -> void:
	pass
func add_nature() -> void:
	pass
func add_forage() -> void:
	pass
func add_monsters() -> void:
	pass

func load():
	pass

func generate():
	pass

func render():
	pass



var tileset_resource =  {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "res://resources/tiles/biome_sets/field/field_stair_tileset.tres",
		GameData.TILE_TAGS.DOOR: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.DOOR_FRAME: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.NATURE: "res://resources/tiles/biome_sets/field/field_nature_tileset.tres",
		GameData.TILE_TAGS.WALL: "res://resources/tiles/biome_sets/field/field_wall_tileset.tres",
	}

var tile_set_draw_data ={
	GameData.TILE_TAGS.FLOOR: {
		"source_id": 0,
		"atlas_coords_max": Vector2i(1, 2), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
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
