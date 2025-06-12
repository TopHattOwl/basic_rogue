class_name SpellFactory
extends Node


## Creates deep copy of item at given path
static func create_spell(spell_resource_path: String) -> SpellResource:
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
	new_spell.spell_type = base_spell.spell_type
	new_spell.spell_subtype = base_spell.spell_subtype
	new_spell.needs_weapon = base_spell.needs_weapon
	new_spell.needs_armor = base_spell.needs_armor

	for component in base_spell.components:
		new_spell.components.append(component.duplicate(true))
			
	return new_spell
