class_name ItemFactory
extends Node


## Creates deep copy of item at given path
static func create_item(item_resource_path: String, count: int = 1) -> ItemResource:
	var base_item = load(item_resource_path)
	if not base_item:
		push_error("item not found at path: " + item_resource_path)
		return null
	
	var new_item = ItemResource.new()
	new_item.uid = base_item.uid
	new_item.display_name = base_item.display_name
	new_item.description = base_item.description
	new_item.item_type = base_item.item_type
	new_item.sprite = base_item.sprite

	for component in base_item.components:
		new_item.components.append(component.duplicate(true))

	if count > 1:
		var stackable_component = new_item.get_component(StackableComponent)
		if stackable_component:
			stackable_component.count = count

	# init items item window component
	var item_window_comp = new_item.get_component(ItemWindowComponent)
	if item_window_comp:
		new_item.get_component(ItemWindowComponent).fill_interaction_options(new_item)
	
	return new_item
