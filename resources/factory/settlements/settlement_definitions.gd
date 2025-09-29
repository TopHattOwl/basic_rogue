extends Node


var settlement_definitions: Dictionary = {
	GameData.ALL_SETTLEMENTS.START_OUTPOST: {
		"name": "Start Outpost",
		"settlement_type": GameData.WORLD_TILE_TYPES.OUTPOST,
		"top_left_pos": Vector2i(31, 16),
		"id" : GameData.ALL_SETTLEMENTS.START_OUTPOST,
		"class_type": Outpost,
		"paths": {
			Vector2i(31, 16): "res://maps/premade_maps/first_outpost.tscn"
		}
	},
	GameData.ALL_SETTLEMENTS.TEST_CITY: {
		"name": "Test City",
		"settlement_type": GameData.WORLD_TILE_TYPES.CITY,
		"top_left_pos": Vector2i(55, 9),
		"id" : GameData.ALL_SETTLEMENTS.TEST_CITY,
		"class_type": City,
		"paths": {
			Vector2i(55, 9): "res://maps/premade_maps/test_city/test_city_0_0.tscn",
			Vector2i(55, 10): "res://maps/premade_maps/test_city/test_city_0_1.tscn",
			Vector2i(56, 9): "res://maps/premade_maps/test_city/test_city_1_0.tscn",
			Vector2i(56, 10): "res://maps/premade_maps/test_city/test_city_1_1.tscn",
		}
	},
	GameData.ALL_SETTLEMENTS.STARTING_VILLAGE: {
		"name": "Starting Village",
		"settlement_type": GameData.WORLD_TILE_TYPES.VILLAGE,
		"top_left_pos": Vector2i(38, 8),
		"id" : GameData.ALL_SETTLEMENTS.STARTING_VILLAGE,
		"class_type": Village,
		"paths": {
			Vector2i(38, 8): "res://maps/premade_maps/starting_village/starting_village_0_0.tscn",
			Vector2i(39, 8): "res://maps/premade_maps/starting_village/starting_village_1_0.tscn",
		}
	},
	GameData.ALL_SETTLEMENTS.TEST_OUTPOST: {
		"name": "Test Outpost",
		"settlement_type": GameData.WORLD_TILE_TYPES.OUTPOST,
		"top_left_pos": Vector2i(44, 12),
		"id" : GameData.ALL_SETTLEMENTS.TEST_OUTPOST,
		"class_type": Outpost,
		"paths": {
			Vector2i(44, 12): "res://maps/premade_maps/test_outpost/test_outpost.tscn",
		}
	},
}