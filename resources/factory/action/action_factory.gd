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

    var _action = Action.new(action_type, cost, is_success)
    return _action


