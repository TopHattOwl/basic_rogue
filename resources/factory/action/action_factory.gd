class_name ActionFactory
extends Node

## Creates an action [br]
## base value is WAIT action, with `is_success` set to `false`
static func make_action(data: Dictionary = {}) -> Action:

	# entity performing the action
	var _entity: Node2D = data.get("entity", null)
	var _item: ItemResource = data.get("item", null)

	var action_type: int = data.get("action_type", GameData.ACTIONS.WAIT)
	var cost: int = data.get("cost", GameData.get_action_cost(action_type))
	var is_success: bool = data.get("is_success", false)

	if action_type == GameData.ACTIONS.MELEE_ATTACK:
		cost = ModifierSystem.get_modified_value(_entity, "melee_attack_cost", GameData.ComponentKeys.ENERGY)

	var energy_comp: EnergyComponent = _entity.get_component(GameData.ComponentKeys.ENERGY)
	var final_cost = energy_comp.get_effective_cost(cost)
	var _action = Action.new(action_type, final_cost, is_success)
	return _action
