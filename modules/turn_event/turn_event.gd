class_name TurnEvent
extends Node2D

var components: Node

func _init() -> void:
	var _components_node = Node.new()
	_components_node.name = "Components"
	add_child(_components_node)
	components = _components_node

	var energy_comp: EnergyComponent = EnergyComponent.new()
	energy_comp.name = GameData.get_component_name(GameData.ComponentKeys.ENERGY)
	energy_comp.time_value = 100
	components.add_child(energy_comp)


func get_time_value() -> int:
	return get_component(GameData.ComponentKeys.ENERGY).time_value

func get_component(component_key: int) -> Node:
	return get_node("Components").get_node(GameData.get_component_name(component_key))

## adds 100 turn TurnEvent's time_value
func pass_turn() -> void:
	var energy_comp: EnergyComponent = get_component(GameData.ComponentKeys.ENERGY)
	energy_comp.time_value += 100
