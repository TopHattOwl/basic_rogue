class_name ItemFactory
extends Node

static var COMPONENT_MAP: Dictionary = {}



# --- PUBLIC METHODS ---

## Creates an item from given ID
static func create_item(item_id: int, count: int = 1) -> ItemResource:

	var definition: Dictionary = ItemDefinitions.get_item_definition(item_id)
	if definition.is_empty():
		push_error("no item definition for item with ID: " + str(item_id))
		return null

	return _build_item_from_definition(definition, count)



## Creates an item from definition dictionary (could be useful for modified/generated items or loading saves)
static func create_item_from_definition(definition: Dictionary, count: int = 1) -> ItemResource:
	return _build_item_from_definition(definition, count)


static func set_component_map() -> void:
	COMPONENT_MAP = {
		"EquipableComponent": EquipableComponent,
		"MeleeWeaponComponent": MeleeWeaponComponent,
		"ArmorComponent": ArmorComponent,
		"StackableComponent": StackableComponent,
		"PowderComponent": PowderComponent,
		"CapacityComponent": CapacityComponent,
		# "DurabilityComponent": DurabilityComponent,
		# "RuneSocketComponent": RuneSocketComponent,

		"ItemWindowComponent": ItemWindowComponent
	}


# --- PRIVATE METHODS ---

static func _build_item_from_definition(definition: Dictionary, count: int) -> ItemResource:
	var item = ItemResource.new()
	var base_data = definition.get("base_data", {})
	
	# set base data
	item.id = base_data.get("id", 0)
	item.uid = base_data.get("uid", "")
	item.display_name = base_data.get("display_name", "Unnamed Item")
	item.description = base_data.get("description", "")
	item.item_type = base_data.get("item_type", 0)
	
	# load sprite
	var sprite_path = base_data.get("sprite_path", "")
	if sprite_path != "":
		item.sprite = load(sprite_path)
	else:
		item.sprite = PlaceholderTexture2D.new()
	
	# build and attach components
	var components_data = definition.get("components", {})
	for component_name in components_data:
		var component = _create_component(component_name, components_data[component_name])
		if component:
			item.components.append(component)
	
	# handle stack count for stackable items
	if count > 1:
		var stackable = item.get_component(StackableComponent)
		if stackable:
			stackable.count = count

	
	# add item window component to all items
	_add_item_window_component(item)
	
	return item

## Creates a component instance from definition data, sets component data as well
static func _create_component(component_name: String, component_data: Dictionary = {}) -> ItemComponent:
	if not COMPONENT_MAP.has(component_name):
		push_warning("Unknown component type: " + component_name)
		return null
	
	var component_class = COMPONENT_MAP[component_name]
	var component = component_class.new()

	# if no data given, no data needed for component
	if component_data.is_empty():
		return component
	
	# Set component properties from data
	_apply_component_data(component, component_data)
	
	return component


## Applies data dictionary to component properties
static func _apply_component_data(component: ItemComponent, component_data: Dictionary) -> void:
	for property in component_data:
		var value = component_data[property]

		if property in component:
			component.set(property, value)


static func _add_item_window_component(item: ItemResource) -> void:
	var window_component = _create_component("ItemWindowComponent")

	if not window_component:
		push_error("Failed to create item window component for item with ID: " + str(item.id))
		return

	item.components.append(window_component)

