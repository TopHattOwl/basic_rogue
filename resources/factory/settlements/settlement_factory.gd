class_name SettlementFactory
extends Node



## makes the settlement and adds it to the settlements map in world map data [br]
## Also adds the premade maps to the world
static func make_settlement(data: Dictionary) -> SettlementTile:
	var class_type = data.get("class_type", SettlementTile)
	var settlement = class_type.new()

	settlement.setup(data)

	# adding the premade maps to the world
	add_premade_maps(data)
	# world_map2.add_premade_map(, Vector2i(55, 9))

	# adding the settlement to the world map data
	WorldMapData.settlements.add_settlement(settlement)
	return settlement

static func add_premade_maps(data: Dictionary) -> void:
	var paths: Dictionary = data.get("paths", {})

	if not paths:
		push_error("settlement has no paths for premade maps\nname: {0}, id: {1}".format([data.name, data.id]))
		return

	# adding the premade maps to the world 
	for grid_pos in paths.keys():
		WorldMapData.world_map2.add_premade_map(paths[grid_pos], grid_pos)
