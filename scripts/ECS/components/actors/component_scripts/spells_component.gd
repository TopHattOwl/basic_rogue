class_name SpellsComponent
extends Node

var learnt_spells: Array[SpellResource]


## Base spell casting func -> calls specific spell casting func
func cast_spell(_spell: SpellResource, _target_grid: Vector2i = Vector2i.ZERO) -> bool:
	var _caster = get_parent().get_parent()
	# check if spell can be cast
	if !can_be_cast(_spell, _caster):
		return false

	# make casted spell data

	var spell_casted_data = {
		"spell": _spell,
		"caster": _caster,
		"target_grid": _target_grid
	}

	_spell._call_component_method({
		"method_name": "on_cast",
		"entity": _caster,
		"target": _target_grid
	})

	SignalBus.spell_casted.emit(spell_casted_data)

	return true
	# match _spell.spell_type:
	# 	GameData.SPELL_TYPE.OFFENSIVE:
	# 		cast_offensive(_spell, _entity, _target_grid)
	# 	GameData.SPELL_TYPE.DEFENSIVE:
	# 		cast_defensive(_spell, _entity, _target_grid)
	# 	_:
	# 		push_error("unhandled spell type: " + str(_spell.spell_type))
	# 		return false

	# # if not problem with casting, return true
	# return true

# OFFENSIVE SPELLS
# func cast_offensive(_spell: SpellResource, _entity: Node2D, _target_grid: Vector2i) -> void:
# 	match _spell.spell_subtype:
# 		GameData.SPELL_SUBTYPE.SINGLE_TARGET:
# 			pass
			 
# 		GameData.SPELL_SUBTYPE.AOE:
# 			pass
# 		GameData.SPELL_SUBTYPE.ARMAMENT_BOOST:
# 			pass 

# 		# unhandled sub type error handling
# 		_:
# 			push_error("unhandled offensive spell subtype: " + str(_spell.spell_subtype))
# 			return
	




# DEFENSIVE SPELLS
# func cast_defensive(_spell: SpellResource, _entity: Node2D, _target_grid: Vector2i) -> bool:
# 	match _spell.spell_subtype:
# 		GameData.SPELL_SUBTYPE.ARMOR_INFUSE:
# 			return true


# 		# unhandled sub type error handling
# 		_:
# 			push_error("unhandled defensive spell subtype: " + str(_spell.spell_subtype))
# 			return false



# CHECKERS

func can_be_cast(_spell: SpellResource, _entity: Node2D) -> bool:
	match _spell.spell_type:
		GameData.SPELL_TYPE.OFFENSIVE:
			return can_be_cast_offensive(_spell, _entity)
		GameData.SPELL_TYPE.DEFENSIVE:
			return can_be_cast_defensive(_spell, _entity)
	
	return false


func can_be_cast_offensive(_spell: SpellResource, _entity: Node2D) -> bool:
	return true


func can_be_cast_defensive(_spell: SpellResource, _entity: Node2D) -> bool:
	return true
