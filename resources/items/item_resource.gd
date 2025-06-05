class_name ItemResource
extends Resource

# An item will be an instance of this resource, created in Godot. 
# each item can have multiple components


@export var uid: String = "" # unique identifier, the name of the item
@export var display_name: String = "Unnamed Item"
@export var description: String = ""
@export var item_type: int # from enum ITEM_TYPES

@export var components: Array[ItemComponent] = []

@export var sprite: Texture2D

## Returns the component of the item. param _type should be the class_name of the component
func get_component(_type: Variant) -> Variant:
	var component: Variant = null
	for comp in components:
		if comp.get_script() == _type:
			component = comp
			break

	if component:
		return component
	else:
		push_error("Item {0} has no component of type {1}".format([str(uid), str(_type)]))
		return null

## Overriden default duplicate to proper component copying [br]
## if `param subresources` is ture deep copy is created -> duplicates subresources as well 
func create_instance(subresources: bool = false) -> Resource:
	var instance = self.duplicate(subresources)

	# deep copy components array
	instance.components = Array()
	for comp in components:
		instance.components.append(comp.duplicate(true))
	return instance
	
