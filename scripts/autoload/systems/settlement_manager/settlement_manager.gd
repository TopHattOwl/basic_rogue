extends Node

var debug: int

var last_settlement_id: int = -1

func _ready() -> void:
	debug = GameData.settlement_manager_debug
	SignalBus.entered_premade_map.connect(_on_entered_premade_map)
	SignalBus.world_map_pos_changed.connect(_on_world_map_pos_changed)

	load_premade_settlements()


func _on_entered_premade_map(data: Dictionary) -> void:
	var settlement = WorldMapData.settlements.get_settlement_by_pos(data.world_pos)
	
	# if premade map is not a settlement, then exit
	if not settlement:
		if debug:
			print(" ---- SETTLEMENT MANAGER ---- ")  
			print("player entered non settlement premade map, exiting")
		return

	
	if debug:
		print(" ---- SETTLEMENT MANAGER ---- ")    
		print("___ player entered premade map ___")
		print("world pos: ", data.world_pos)
		print("settlement:\n- name: {0}\n- id: {1}\n- type: {2}".format([settlement.name, settlement.id, settlement.get_script().get_path()]))
		if last_settlement_id == settlement.id:
			print("\tplayer entered the same settlement")

	last_settlement_id = settlement.id

func _on_world_map_pos_changed(to: Vector2i, _from: Vector2i) -> void:
	var settlement = WorldMapData.settlements.get_settlement_by_pos(to)

	if not settlement:
		last_settlement_id = -1 # reset last settlement id to not settlement
		return


func load_premade_settlements() -> void:
	SettlementFactory.make_settlement(SettlementDefinitions.settlement_definitions[GameData.ALL_SETTLEMENTS.TEST_CITY])
	SettlementFactory.make_settlement(SettlementDefinitions.settlement_definitions[GameData.ALL_SETTLEMENTS.STARTING_VILLAGE])
	SettlementFactory.make_settlement(SettlementDefinitions.settlement_definitions[GameData.ALL_SETTLEMENTS.START_OUTPOST])
	SettlementFactory.make_settlement(SettlementDefinitions.settlement_definitions[GameData.ALL_SETTLEMENTS.TEST_OUTPOST])