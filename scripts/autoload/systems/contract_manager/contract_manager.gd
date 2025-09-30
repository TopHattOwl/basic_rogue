extends Node

const DAYS_SINCE_LAST_CONTRACT = 2
const MAX_CONTRACTS = 5

var debug := GameData.contract_debug

var contracts: Array[Contract]


func _ready() -> void:
	
	SignalBus.day_passed.connect(_on_day_passed)


func _on_day_passed() -> void:
	
	check_settlements()


func check_settlements() -> void:

	var all_settlements = WorldMapData.settlements.settlements
	if debug:
		print(" ---- CONTRACT MANAGER ---- ")
		print(" Checking settlements for contract generation")
	for settlement in all_settlements:
		if debug:
			print(" --- checking settlement:")
			print(settlement.get_debug_info())
		
		var needs_contract = settlement.contract_data.needs_contract()
		if not needs_contract:
			if debug:
				print("contract not needed for settlement")
			continue
		
		if debug:
			print("contract needed for settlement")
		generate_contract(settlement)


func generate_contract(settlement: SettlementTile) -> void:

	var contract = ContractFactory.make_contract({"settlement": settlement})
	contracts.append(contract)

	if debug:
		print(" ---- generating contract ")
		print("___ Contract Generated ___")
		print("contract data:\n", contract.get_debug_info())