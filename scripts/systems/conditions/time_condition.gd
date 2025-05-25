class_name TimeCondition
extends Condition

@export var required_time: StringName

func is_met(_entity: Node2D = null) -> bool:
    return GameTime.current_time == required_time