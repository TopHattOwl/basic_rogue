extends Node


func get_dungeon_data(dungeon_pos) -> Dictionary:
	return {
		"world_map_pos": dungeon_pos,
		"rng_seed": (GameData.main_rng.seed % (dungeon_pos.y + 1)) * (dungeon_pos.y + 1) * (dungeon_pos.x + 1)
	}



var dungeon_definitions = {

	# --- FIELD ---
	GameData.WORLD_TILE_TYPES.FIELD: {
		GameData.DUNGEON_TYPES.CASTLE: {

		},
		GameData.DUNGEON_TYPES.CAVE: {

		},
		GameData.DUNGEON_TYPES.TEMPLE: {

		},
		GameData.DUNGEON_TYPES.CAMP: {

		},
		GameData.DUNGEON_TYPES.TOWER: {

		},
	},


	# --- FOREST ---
	GameData.WORLD_TILE_TYPES.FOREST: {
		GameData.DUNGEON_TYPES.CASTLE: {

		},
		GameData.DUNGEON_TYPES.CAVE: {

		},
		GameData.DUNGEON_TYPES.TEMPLE: {

		},
		GameData.DUNGEON_TYPES.CAMP: {

		},
		GameData.DUNGEON_TYPES.TOWER: {

		},
	},


	# --- DESERT ---
	GameData.WORLD_TILE_TYPES.DESERT: {
		GameData.DUNGEON_TYPES.CASTLE: {

		},
		GameData.DUNGEON_TYPES.CAVE: {

		},
		GameData.DUNGEON_TYPES.TEMPLE: {

		},
		GameData.DUNGEON_TYPES.CAMP: {

		},
		GameData.DUNGEON_TYPES.TOWER: {

		},
	},


	# --- MOUNTAIN ---
	GameData.WORLD_TILE_TYPES.MOUNTAIN: {
		GameData.DUNGEON_TYPES.CASTLE: {

		},
		GameData.DUNGEON_TYPES.CAVE: {

		},
		GameData.DUNGEON_TYPES.TEMPLE: {

		},
		GameData.DUNGEON_TYPES.CAMP: {

		},
		GameData.DUNGEON_TYPES.TOWER: {

		},
	},


	# --- SWAMP ---
	GameData.WORLD_TILE_TYPES.SWAMP: {
		GameData.DUNGEON_TYPES.CASTLE: {

		},
		GameData.DUNGEON_TYPES.CAVE: {

		},
		GameData.DUNGEON_TYPES.TEMPLE: {

		},
		GameData.DUNGEON_TYPES.CAMP: {

		},
		GameData.DUNGEON_TYPES.TOWER: {

		},
	},
}
