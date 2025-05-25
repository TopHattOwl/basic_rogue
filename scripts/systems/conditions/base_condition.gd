class_name Condition
extends Resource

# each condition class extends Condition, it has to implement is_met, each Condition type has different is_met conditions

func is_met(_entity: Node2D = null) -> bool:
    return false