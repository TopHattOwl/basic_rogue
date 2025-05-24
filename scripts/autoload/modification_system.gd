class_name ModificationSystem
extends Node

## applies modifiers, to entity's given component using ``modified_comp`` param 
static func get_modified_value(entity: Node2D, modified_comp: int, modified_thing: StringName, modifier: float) -> float:

    # getting the component
    var comp = ComponentRegistry.get_component(entity, modified_comp)
    var modified_value = 0.0
    if comp:
        modified_value = comp.get(modified_thing) * modifier

    return modified_value