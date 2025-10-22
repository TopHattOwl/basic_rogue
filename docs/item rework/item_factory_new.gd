# class_name ItemFactory
# extends Node

# # Component class mapping - maps component names to their classes
# const COMPONENT_MAP = {
# 	"EquipableComponent": EquipableComponent,
# 	"MeleeWeaponComponent": MeleeWeaponComponent,
# 	"ArmorComponent": ArmorComponent,
# 	"StackableComponent": StackableComponent,
# 	"ConsumableComponent": ConsumableComponent,
# 	"HealingComponent": HealingComponent,
# 	"CapacityComponent": CapacityComponent,
# 	"DurabilityComponent": DurabilityComponent,
# 	"RuneSocketComponent": RuneSocketComponent,
# 	# Add more component mappings as needed
# }


# ## Creates an item from item definition ID
# static func create_item(item_id: int, count: int = 1) -> ItemResource:
# 	var definition = ItemDefinitions.get_item_definition(item_id)
# 	if definition.is_empty():
# 		push_error("Cannot create item with ID: " + str(item_id))
# 		return null
	
# 	return _build_item_from_definition(definition, count)


# ## Creates an item from definition dictionary (useful for modified/generated items)
# static func create_item_from_definition(definition: Dictionary, count: int = 1) -> ItemResource:
# 	return _build_item_from_definition(definition, count)


# ## Internal method to construct item from definition
# static func _build_item_from_definition(definition: Dictionary, count: int) -> ItemResource:
# 	var item = ItemResource.new()
# 	var base_data = definition.get("base_data", {})
	
# 	# Set base properties
# 	item.uid = base_data.get("uid", "")
# 	item.display_name = base_data.get("display_name", "Unnamed Item")
# 	item.description = base_data.get("description", "")
# 	item.item_type = base_data.get("item_type", 0)
	
# 	# Load sprite if path provided
# 	var sprite_path = base_data.get("sprite_path", "")
# 	if sprite_path != "":
# 		item.sprite = load(sprite_path)
	
# 	# Build and attach components
# 	var components_data = definition.get("components", {})
# 	for component_name in components_data:
# 		var component = _create_component(component_name, components_data[component_name])
# 		if component:
# 			item.components.append(component)
	
# 	# Handle stack count for stackable items
# 	if count > 1:
# 		var stackable = item.get_component(StackableComponent)
# 		if stackable:
# 			stackable.count = count
	
# 	return item


# ## Creates a component instance from definition data
# static func _create_component(component_name: String, component_data: Dictionary) -> ItemComponent:
# 	if not COMPONENT_MAP.has(component_name):
# 		push_warning("Unknown component type: " + component_name)
# 		return null
	
# 	var component_class = COMPONENT_MAP[component_name]
# 	var component = component_class.new()
	
# 	# Set component properties from data
# 	_apply_component_data(component, component_data)
	
# 	return component


# ## Applies data dictionary to component properties
# static func _apply_component_data(component: ItemComponent, data: Dictionary) -> void:
# 	for property in data:
# 		var value = data[property]
		
# 		# Special handling for certain property types
# 		match property:
# 			"bonuses":
# 				# Convert bonus dictionaries to StatModifier resources
# 				component.set(property, _create_stat_modifiers(value))
# 			"resistances":
# 				# Resistances are already in dict format, just assign
# 				component.set(property, value.duplicate())
# 			_:
# 				# Direct assignment for simple properties
# 				if property in component:
# 					component.set(property, value)


# ## Converts bonus data to StatModifier array
# static func _create_stat_modifiers(bonuses_data: Array) -> Array[StatModifier]:
# 	var modifiers: Array[StatModifier] = []
	
# 	for bonus_data in bonuses_data:
# 		if bonus_data is Dictionary:
# 			var modifier = StatModifier.new()
# 			modifier.stat = bonus_data.get("stat", 0)
# 			modifier.value = bonus_data.get("value", 0)
# 			modifier.modifier_type = bonus_data.get("type", GameData.MODIFIER_TYPE.FLAT)
# 			modifiers.append(modifier)
# 		elif bonus_data is StatModifier:
# 			# Already a StatModifier, just add it
# 			modifiers.append(bonus_data.duplicate(true))
	
# 	return modifiers


# ## Creates a modified copy of an item (for enchantments, runes, etc.)
# static func create_modified_item(base_item_id: int, modifications: Dictionary) -> ItemResource:
# 	var definition = ItemDefinitions.get_item_definition(base_item_id)
# 	if definition.is_empty():
# 		return null
	
# 	# Deep copy the definition
# 	var modified_def = _deep_copy_dict(definition)
	
# 	# Apply modifications
# 	_apply_modifications(modified_def, modifications)
	
# 	return _build_item_from_definition(modified_def, 1)


# ## Applies modifications to item definition
# static func _apply_modifications(definition: Dictionary, modifications: Dictionary) -> void:
# 	# Modify base data
# 	if modifications.has("base_data"):
# 		for key in modifications["base_data"]:
# 			definition["base_data"][key] = modifications["base_data"][key]
	
# 	# Modify components
# 	if modifications.has("components"):
# 		for comp_name in modifications["components"]:
# 			if not definition["components"].has(comp_name):
# 				# Add new component
# 				definition["components"][comp_name] = modifications["components"][comp_name]
# 			else:
# 				# Merge with existing component data
# 				for prop in modifications["components"][comp_name]:
# 					definition["components"][comp_name][prop] = modifications["components"][comp_name][prop]


# ## Deep copy dictionary helper
# static func _deep_copy_dict(dict: Dictionary) -> Dictionary:
# 	var result = {}
# 	for key in dict:
# 		if dict[key] is Dictionary:
# 			result[key] = _deep_copy_dict(dict[key])
# 		elif dict[key] is Array:
# 			result[key] = dict[key].duplicate(true)
# 		else:
# 			result[key] = dict[key]
# 	return result


# ## Create an enchanted/improved weapon (example for your rune system)
# static func create_enchanted_weapon(base_weapon_id: int, enchantment_data: Dictionary) -> ItemResource:
# 	var modifications = {
# 		"base_data": {
# 			"display_name": enchantment_data.get("prefix", "") + " " + ItemDefinitions.get_item_definition(base_weapon_id)["base_data"]["display_name"],
# 			"rarity": enchantment_data.get("new_rarity", GameData.RARITY.UNCOMMON),
# 		},
# 		"components": {
# 			"MeleeWeaponComponent": {
# 				"damage_min": enchantment_data.get("damage_bonus_min", 0),
# 				"damage_max": enchantment_data.get("damage_bonus_max", 0),
# 				"bonuses": enchantment_data.get("additional_bonuses", []),
# 			}
# 		}
# 	}
	
# 	var item = create_modified_item(base_weapon_id, modifications)
	
# 	# Add rune sockets if specified
# 	if enchantment_data.has("rune_sockets"):
# 		var socket_comp = RuneSocketComponent.new()
# 		socket_comp.max_sockets = enchantment_data["rune_sockets"]
# 		item.components.append(socket_comp)
	
# 	return item