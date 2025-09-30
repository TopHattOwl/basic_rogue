class_name SettlementTile
extends Resource
## base settlement class
## one settlement is one instance of this class
## 


var name: String

var id: int

var settlement_type: int
var positions: Array[Vector2i]
var size: Vector2i

var contract_data: ContractData


func _init() -> void:
	pass
	

func setup(d: Dictionary) -> void:
	settlement_type = d.get("settlement_type", GameData.WORLD_TILE_TYPES.OUTPOST)
	name = d.get("name", "unnamed settlement")
	id = d.get("id", -1)

	var top_left_pos: Vector2i = d.get("top_left_pos", Vector2i(0, 0))

	match settlement_type:
		GameData.WORLD_TILE_TYPES.OUTPOST:
			size = Vector2i(1, 1)
		GameData.WORLD_TILE_TYPES.VILLAGE:
			size = Vector2i(2, 1)
		GameData.WORLD_TILE_TYPES.CITY:
			size = Vector2i(2, 2)
		_:
			size = Vector2i(1, 1)
	

	# getting the positions
	positions = []

	if size != Vector2i(1, 1):
		for y in range(size.y):
			for x in range(size.x):
				positions.append(Vector2i(top_left_pos.x + x, top_left_pos.y + y))
	else:# if size is 1x1 then just top left pos
		positions.append(top_left_pos)

	
	# contracts
	contract_data = ContractData.new()


func get_debug_info() -> String:
	var info = "_____\n"
	info += "- Name: " + name + "\n"
	info += "- ID: " + str(id) + "\n"
	info += "- Type: " + str(settlement_type) + "\n"
	info += "- Size: " + str(size) + "\n"
	info += "- Positions: " + str(positions) + "\n"
	info += "_____\n"
	return info



class ContractData:
	var days_since_last_contract: int
	var contracts: Array # references for the Contract object in contract manager
	var num_of_contracts: int
	var max_contracts: int


	func _init(data: Dictionary = {}) -> void:
		days_since_last_contract = data.get("days_since_last_contract", 5)
		contracts = data.get("contracts", [])
		num_of_contracts = data.get("num_of_contracts", 0)
		max_contracts = data.get("max_contracts", 5)

	func needs_contract() -> bool:
		var day_random = randi_range(2,3)

		return days_since_last_contract >= day_random and num_of_contracts < max_contracts

	func contract_added() -> void:
		days_since_last_contract = 0
		num_of_contracts += 1
