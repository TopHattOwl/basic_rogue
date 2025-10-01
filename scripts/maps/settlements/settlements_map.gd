class_name SettlementsMap
extends Resource

var settlements: Array[SettlementTile]


func _init() -> void:
	SignalBus.day_passed.connect(_on_day_passed)
	SignalBus.contract_generated.connect(_on_contract_generated)

func add_settlement(settlement: SettlementTile) -> void:
	settlements.append(settlement)

func get_settlement_by_id(id: int) -> SettlementTile:

	var i = settlements.find_custom(func(settlement: SettlementTile) -> bool:
		return settlement.id == id)
	if i == -1:
		return null
	return settlements[i]

func get_settlement_by_pos(pos: Vector2i) -> SettlementTile:

	var i = settlements.find_custom(func(settlement: SettlementTile) -> bool:
		return settlement.positions.has(pos)
	)
	if i == -1:
		return null
	return settlements[i]

func get_settlement_by_name(name: String) -> SettlementTile:

	var i = settlements.find_custom(func(settlement: SettlementTile) -> bool:
		return settlement.name == name
	)
	if i == -1:
		return null
	return settlements[i]


func _on_day_passed() -> void:
	for settlement in settlements:
		settlement.contract_data.days_since_last_contract += 1


func _on_contract_generated(data: Dictionary) -> void:
	var contract = data.get("contract", null)
	var settlement: SettlementTile = contract.settlement

	if not settlement:
		push_error("contract has no settlement")
		return

	settlement.contract_data.contract_added()

# save and load

func save_settlements() -> void:
	pass


func load_settlements() -> void:
	pass
