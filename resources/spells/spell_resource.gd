class_name SpellResource
extends Resource
## A spell will be an instance of this resource, created in Godot. 
## each spell can have multiple components



@export var uid: String = "" # unique identifier, the name of the item
@export var display_name: String = "Unnamed Spell"
@export var description: String = ""
@export var element: int # from enum ELEMENT
@export var capacity_cost: int

@export var components: Array[SpellComponent] = []

@export var icon: Texture2D

# casting requirements
@export var needs_weapon: bool = false
@export var needs_armor: bool = false
@export var needs_shield: bool = false

## wheather the spell needs to be aimed by player when trying to cast it from hotbar
@export var needs_aiming: bool = false


## Returns the component of the spell. param _type should be the class_name of the component [br]
## returns null if not found
func get_component(_type: Variant) -> Variant:
	var component: Variant = null
	for comp in components:
		if comp.get_script() == _type:
			component = comp
			break

	if component:
		return component
	else:
		push_warning("Spell {0} has no component of type {1}. If no error for null reference, this may be ignored".format([str(uid), str(_type)]))
		return null


## Calls the given `method_name` on all components [br]
## given dictionary needs: `caster`, `method_name`[br]
## Can have: `target_grid`
func _call_component_method(d: Dictionary) -> void:
	var caster = d.get("caster", null)
	var method_name = d.get("method_name", "")
	var target = d.get("target", null)
	var spell_instance = d.get("spell_instance", null)
	for comp in components:
		if comp.has_method(method_name):

			# base methods need item and caster
			# where more is required make special case
			match method_name:
				_:
					comp.call(method_name, self, spell_instance, caster, target)


