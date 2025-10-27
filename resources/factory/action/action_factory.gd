class_name ActionFactory
extends Node

const MIN_ACTION_COST: int = 20

## Creates an action [br]
## base value is WAIT action, with `is_success` set to `false`
static func make_action(data: Dictionary = {}) -> Action:

	# entity performing the action
	var _entity: Node2D = data.get("entity", null)
	var _item: ItemResource = data.get("item", null)

	var action_type: int = data.get("action_type", GameData.ACTIONS.WAIT)
	var cost: int = data.get("cost", GameData.get_action_cost(action_type))
	var is_success: bool = data.get("is_success", false)

	# print("[ActionFactory] base cost: ", cost)

	if action_type == GameData.ACTIONS.MELEE_ATTACK:
		cost = ModifierSystem.get_modified_value(_entity, "melee_attack_cost", GameData.ComponentKeys.ENERGY)

	
	# print("[ActionFactory] cost after adding specific modifiers: ", cost)

	var energy_comp: EnergyComponent = _entity.get_component(GameData.ComponentKeys.ENERGY)
	var final_cost = max(MIN_ACTION_COST, energy_comp.get_effective_cost(cost))

	# print("[ActionFactory] final cost after getting effective speed: ", final_cost)
	var _action = Action.new(action_type, final_cost, is_success)

	# print("[ActionFactory] action is made, cost: ", _action.cost)
	return _action
