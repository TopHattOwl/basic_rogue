class_name ItemResource
extends Resource

# An item will be an instance of this resource, created in Godot. 
# each item can have multiple components

@export var id: int
@export var uid: String = "" # unique identifier, the name of the item
@export var display_name: String = "Unnamed Item"
@export_multiline var description: String = ""
@export var item_type: int # from enum ITEM_TYPES

@export var components: Array[ItemComponent] = []

@export var sprite: Texture2D

@export var rarity: GameData.RARITY
@export var value: int

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
		push_warning("Item {0} has no component of type {1}. If no error for null reference, this may be ignored".format([str(uid), str(_type.get_global_name())]))
		return null
	
## Calls the given `method_name` on all components [br]
## given dictionary needs:`method_name`, `entity`[br]
## Can have: `target`
func _call_component_method(d: Dictionary) -> void:
	var entity = d.get("entity", null)
	var method_name = d.get("method_name", "")
	var target = d.get("target", null)
	for comp in components:
		if comp.has_method(method_name):
			match method_name:
				"on_use":
					comp.call(method_name, self, entity, target)

				_:
					comp.call(method_name, self, entity)
