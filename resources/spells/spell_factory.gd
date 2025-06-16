class_name SpellFactory
extends Node



## Creates deep copy of item at given path
## returns the SpellNode with deep copied SpellResource
static func create_spell(spell_resource_path: String, spell_scene_path: String) -> SpellNode:
	var base_spell = load(spell_resource_path)
	if not base_spell:
		push_error("item not found at path: " + spell_resource_path)
		return null
	
	var new_spell = SpellResource.new()
	new_spell.uid = base_spell.uid
	new_spell.display_name = base_spell.display_name
	new_spell.description = base_spell.description
	new_spell.element = base_spell.element
	new_spell.capacity_cost = base_spell.capacity_cost
	new_spell.icon = base_spell.icon
	new_spell.needs_weapon = base_spell.needs_weapon
	new_spell.needs_armor = base_spell.needs_armor
	new_spell.needs_aiming = base_spell.needs_aiming

	for component in base_spell.components:
		new_spell.components.append(component.duplicate(true))


	var new_spell_node: SpellNode = load(spell_scene_path).instantiate().duplicate()

	new_spell_node.spell_data = new_spell
	new_spell_node.set_uid()

	new_spell_node.set_data()
	
	return new_spell_node
