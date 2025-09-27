extends Node

var debug := GameData.contract_debug

var settlement_contracts: Dictionary

func _ready() -> void:
	SignalBus.day_passed.connect(_on_day_passed)

	load_contracts()

	# generate_contract()

func _on_day_passed() -> void:
	# generate_contract()
	pass


func check_settlements() -> void:
	var all_settlements = WorldMapData.settlements.settlements

func generate_contract(settlement: SettlementTile) -> void:
	if debug:
		print(" ---- CONTRACT MANAGER ---- ")
		print("day passed cheking settlements ")
	

	var contract = ContractFactory.make_contract(generate_contract_data())

	print("___ Contract Generated ___")
	print("contract data:\n", contract.get_debug_info())
		
func generate_contract_data() -> Dictionary:
	return {}



# SAVE / LOAD

# for now just make settlement_contracts
func load_contracts() -> void:
	make_settlement_contracts_base()


func make_settlement_contracts_base() -> void:
	pass
