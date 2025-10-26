class_name Action
extends Resource


# from GameData.ACTIONS
var action_type: int

var cost: int

# delay in miliseconds
var delay: float

var is_success: bool


func _init(_action_type: int, _cost: int = -1, _is_success: bool = false) -> void:
    action_type = _action_type

    if _cost == -1:
        cost = GameData.get_action_cost(_action_type)
    else:
        cost = _cost
        
    is_success = _is_success

    delay = GameData.get_action_delay(_action_type)

