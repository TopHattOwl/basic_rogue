extends Node


func _ready() -> void:
	load_biome_datas()
	load_dungeon_datas()


## loads in all biome tilesets 
func load_biome_datas() -> void:
	var _biome_tileset_resource: Dictionary = {}

	for world_tile_type in GameData.WORLD_TILE_TYPES:

		# skip non-hostile biomes -> no map generation for those
		if not GameData.WORLD_TILE_TYPES[world_tile_type] in GameData.HostileBiomes:
			continue
		var current_biome_tileset_resource = {}

		for tile_tag in GameData.TILE_TAGS:
			if GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.NONE:
				continue

			# special edge case for door frame (same tileset as door)
			if GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.DOOR_FRAME:
				var _directory: String = world_tile_type.to_lower()
				var _file_name: String = world_tile_type.to_lower() + "_" + "door"
				var _path: String = "res://resources/tiles/biome_sets/%s/%s_tileset.tres" % [_directory, _file_name]
				if not FileAccess.file_exists(_path):
					_path = "res://resources/tiles/biome_sets/field/field_door_tileset.tres"
				current_biome_tileset_resource[GameData.TILE_TAGS[tile_tag]] = _path
				continue

			var directory: String = world_tile_type.to_lower()
			var file_name: String = world_tile_type.to_lower() + "_" + tile_tag.to_lower()
			var path: String = "res://resources/tiles/biome_sets/%s/%s_tileset.tres" % [directory, file_name]

			if not FileAccess.file_exists(path):
				path = "res://resources/tiles/biome_sets/field/field_%s_tileset.tres" % [tile_tag.to_lower()]
			current_biome_tileset_resource[GameData.TILE_TAGS[tile_tag]] = path
		_biome_tileset_resource[GameData.WORLD_TILE_TYPES[world_tile_type]] = current_biome_tileset_resource

	biome_tileset_resource = _biome_tileset_resource


func load_dungeon_datas() -> void:
	var _dungeon_tileset_resource: Dictionary = {}

	for dungeon_type in GameData.DUNGEON_TYPES:
		var current_dungeon_tileset_resource = {}
		for tile_tag in GameData.TILE_TAGS:
			if GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.NONE:
				continue

			# ----------
			# skip for now, unlil dungeon generation is complete
			if GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.DOOR_FRAME or GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.DOOR:
				continue
			if GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.NATURE:
				continue
			# ----------

			# special edge case for door frame (same tileset as door)
			if GameData.TILE_TAGS[tile_tag] == GameData.TILE_TAGS.DOOR_FRAME:
				var _directory: String = dungeon_type.to_lower()
				var _file_name: String = dungeon_type.to_lower() + "_" + "door"
				var _path: String = "res://resources/tiles/dungeon_tile_sets/%s/%s_tileset.tres" % [_directory, _file_name]
				if not FileAccess.file_exists(_path):
					_path = "res://resources/tiles/dungeon_tile_sets/cave/cave_door_tileset.tres"
				current_dungeon_tileset_resource[GameData.TILE_TAGS[tile_tag]] = _path
				continue
			
			var directory: String = dungeon_type.to_lower()
			var file_name: String = dungeon_type.to_lower() + "_" + tile_tag.to_lower()
			var path: String = "res://resources/tiles/dungeon_tile_sets/%s/%s_tileset.tres" % [directory, file_name]

			if not FileAccess.file_exists(path):
				path = "res://resources/tiles/dungeon_tile_sets/cave/cave_%s_tileset.tres" % [tile_tag.to_lower()]

			current_dungeon_tileset_resource[GameData.TILE_TAGS[tile_tag]] = path
		_dungeon_tileset_resource[GameData.DUNGEON_TYPES[dungeon_type]] = current_dungeon_tileset_resource

	dungeon_tileset_resource = _dungeon_tileset_resource

# ------------ DUNGEONS ------------

var dungeon_tileset_resource: Dictionary = {}
# Dictionary setup: DungeonTileType: "path_to_tileset.tres"
# tilesets have multiple atlas sources, draw_data will have multiple entries for each world tile types

var dungeon_tileset_draw_data: Dictionary = {
	GameData.DUNGEON_TYPES.CASTLE: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.STAIR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR_FRAME: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
		GameData.TILE_TAGS.NATURE: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
	},


	GameData.DUNGEON_TYPES.CAVE: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.STAIR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR_FRAME: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
		GameData.TILE_TAGS.NATURE: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
	},


	GameData.DUNGEON_TYPES.CAMP: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.STAIR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR_FRAME: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
		GameData.TILE_TAGS.NATURE: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
	},


	GameData.DUNGEON_TYPES.TEMPLE: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.STAIR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR_FRAME: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
		GameData.TILE_TAGS.NATURE: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
	},


	GameData.DUNGEON_TYPES.TOWER: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0), # Vector2i(x, y) where x is the max x coord and y is the max y coord | Vector2i(1, 2) -> 2 tile wilde 3 tile tall grid
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.WALL: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(4, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.STAIR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0),
			"atlas_coords_min": Vector2i(0, 0),
		},
		GameData.TILE_TAGS.DOOR_FRAME: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(1, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
		GameData.TILE_TAGS.NATURE: {
			"source_id": GameData.DUNGEON_TYPES.CAVE,
			"atlas_coords_max": Vector2i(0, 0), 
			"atlas_coords_min": Vector2i(1, 0),
		},
	},
}


# ------------ BIOMES ------------

var biome_tileset_resource: Dictionary = {}
# will look like this:
	# {
		# WORLD_TILE_TYPE: {
			#TILE_TAG: "path_to_tileset.tres",
			#TILE_TAG: "path_to_tileset.tres",
		#}
	# }
# var biome_tileset_resource = {
# 	GameData.WORLD_TILE_TYPES.FIELD: {
# 		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
# 		GameData.TILE_TAGS.STAIR: "res://resources/tiles/biome_sets/field/field_stair_tileset.tres",
# 		GameData.TILE_TAGS.DOOR: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
# 		GameData.TILE_TAGS.DOOR_FRAME: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
# 		GameData.TILE_TAGS.NATURE: "res://resources/tiles/biome_sets/field/field_nature_tileset.tres",
# 		GameData.TILE_TAGS.WALL: "res://resources/tiles/biome_sets/field/field_wall_tileset.tres",
# 	},

var biome_tileset_draw_data = {

	# --- SWAMP ---
	GameData.WORLD_TILE_TYPES.SWAMP: {
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
	},


	# --- FIELD ---
	GameData.WORLD_TILE_TYPES.FIELD: {
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
	},


	# --- MOUNTAIN ---
	GameData.WORLD_TILE_TYPES.MOUNTAIN: {
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
	},


	# --- FOREST ---
	GameData.WORLD_TILE_TYPES.FOREST: {
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
	},


	# --- DESERT ---
	GameData.WORLD_TILE_TYPES.DESERT: {
		GameData.TILE_TAGS.FLOOR: {
			"source_id": 2,
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
	},
}
