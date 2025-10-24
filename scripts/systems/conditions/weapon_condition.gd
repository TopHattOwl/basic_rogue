class_name WeaponCondition
extends Condition
## set variable `required_weapon` to bound a modifier to a specific weapon instance

var required_weapon: ItemResource


## sets `required_weapon` for modifier condition if given
func _init(_required_weapon: ItemResource = null) -> void:
    required_weapon = _required_weapon

func is_met(_entity: Node2D = null) -> bool:
    return ComponentRegistry.get_component(_entity, GameData.ComponentKeys.EQUIPMENT).equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND] == required_weapon