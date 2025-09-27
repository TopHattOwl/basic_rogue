class_name SettlementsMap
extends Resource

var settlements: Array



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
