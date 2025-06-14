class_name SpellsComponent
extends Node

var learnt_spellss: Array[SpellNode]

var learnt_spells: Dictionary


func learn_spell(spell_node: SpellNode) -> void:

	var uid = spell_node.spell_data.uid
	if not learnt_spells.has(uid):
		learnt_spells[uid] = spell_node



## Base spell casting func -> calls specific spell casting func
func cast_spell(uid: String, _target_grid: Vector2i = Vector2i.ZERO) -> bool:
	var _caster = get_parent().get_parent()
	# check if spell can be cast

	if !learnt_spells.has(uid):
		return false
	
	var _spell = learnt_spells[uid]

	if !can_be_cast(_spell, _caster):
		return false

	# make casted spell data

	var spell_casted_data = {
		"spell": _spell,
		"caster": _caster,
		"target_grid": _target_grid
	}


	var spell_instance: SpellNode = _spell.duplicate()

	spell_instance.cast_spell(_caster, _target_grid)

	return true

# CHECKERS

func can_be_cast(_spell: SpellNode, _entity: Node2D) -> bool:
	match _spell.spell_type:
		GameData.SPELL_TYPE.OFFENSIVE:
			return can_be_cast_offensive(_spell, _entity)
		GameData.SPELL_TYPE.DEFENSIVE:
			return can_be_cast_defensive(_spell, _entity)
	
	return false


func can_be_cast_offensive(_spell: SpellNode, _entity: Node2D) -> bool:
	return true


func can_be_cast_defensive(_spell: SpellNode, _entity: Node2D) -> bool:
	return true
