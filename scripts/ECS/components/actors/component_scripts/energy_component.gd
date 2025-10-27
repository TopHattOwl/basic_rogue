class_name EnergyComponent
extends Node

# the base speed of the entity
var base_speed: float = 1.0

## Current time_value accumulated
var time_value: int = 0


## time_value cost variables so modifier system can modify them

var move_cost: int = GameData.get_action_cost(GameData.ACTIONS.MOVE)
var melee_attack_cost: int = GameData.get_action_cost(GameData.ACTIONS.MELEE_ATTACK)
var ranged_attack_cost: int = GameData.get_action_cost(GameData.ACTIONS.RANGED_ATTACK)
var cast_spell_cost: int = GameData.get_action_cost(GameData.ACTIONS.CAST_SPELL)
var change_stance_cost: int = GameData.get_action_cost(GameData.ACTIONS.CHANGE_STANCE)

func _init(_data: Dictionary = {}) -> void:
	var _energy_turn_manager: EnergyTurnManager = GameData.energy_turn_manager
	if _energy_turn_manager == null:
		time_value = 0
		return
	var _turn_event: TurnEvent = GameData.energy_turn_manager.turn_event
	if _turn_event == null:
		time_value = 0
		return
	time_value = _turn_event.get_time_value()


func initialize(data: Dictionary = {}) -> void:
	var _base_speed = data.get("base_speed", 1.0)
	base_speed = _base_speed

## Returns the effective cost of an action based on `base_speed` of entity
func get_effective_cost(action_cost: int) -> int:
	var modifiers_comp: ModifiersComponent = get_parent().get_parent().get_component(GameData.ComponentKeys.MODIFIERS)
	if modifiers_comp == null:
		return int(action_cost / base_speed)
	var speed = ModifierSystem.get_modified_value(
		get_parent().get_parent(),
		"base_speed",
		GameData.ComponentKeys.ENERGY
	)
	return int(action_cost / speed)

## adds time to entity when it acted
func add_time(value: int) -> void:
	time_value += value


## for testing/debugging
func reset_time() -> void:
	time_value = 0
