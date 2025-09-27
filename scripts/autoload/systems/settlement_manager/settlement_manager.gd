extends Node

var debug: int

func _ready() -> void:
	debug = GameData.settlement_manager_debug
	SignalBus.entered_premade_map.connect(_on_entered_premade_map)


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
