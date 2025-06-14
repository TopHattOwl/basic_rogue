class_name SingleTargetComponent
extends SpellComponent


## % of the melee combat component's calculated damage will be the damage of the spell
@export var damage_mod: float
@export var spell_range: int

## speed in tiles per second
@export var speed: int


func on_cast(_spell: SpellResource, _spell_instance: SpellNode, _caster: Node2D, _target_grid: Variant = null) -> void:
	var target = GameData.get_actor(_target_grid)

	if null == target:
		# returning here means no target -> don't have to apply damage
		# this on_cast only handles damaging target, the animations/ other on_cast methods will still run
		return

	var caster_pos = _caster.get_component(GameData.ComponentKeys.POSITION).grid_pos
	var target_pos = target.get_component(GameData.ComponentKeys.POSITION).grid_pos
	var dir = clamp(target_pos - caster_pos, Vector2i(-1, -1), Vector2i(1, 1))

	var caster_melee_combat_comp: MeleeCombatComponent = _caster.get_component(GameData.ComponentKeys.MELEE_COMBAT)
	var base_dam = caster_melee_combat_comp.calc_damage()
	var cast_weapon_element = caster_melee_combat_comp.get_element()

	var actual_damage_mod: float


	# if weapon element is same as spell element -> x15% bonus to damage mod
	# else x15% penalty to damage mod
	if cast_weapon_element == GameData.ELEMENT.PHYSICAL:
		actual_damage_mod = damage_mod
	elif cast_weapon_element == _spell.element:
		actual_damage_mod = damage_mod * 1.15
	else:
		actual_damage_mod = damage_mod * 0.85

	var dam = base_dam * actual_damage_mod

	

	
	print("--- signle target offensive spell ---")
	print("oncast function for single target")
	print("hitting target: ", target)
	print("caster weapon element: ", cast_weapon_element)
	print("damage mod: ", actual_damage_mod)

	var signal_hit_data = {
		"target": target,
		"attacker": _caster,
		"damage": dam,
		"direction": dir,
		"element": _spell.element,
		"hit_action": GameData.HIT_ACTIONS.HIT,
		"combat_type": GameData.COMBAT_TYPE.SPELL
	}

	SignalBus.actor_hit.emit(signal_hit_data)


func calc_damage(spell_node: SpellNode) -> int:
	var caster_melee_combat_comp: MeleeCombatComponent = spell_node.caster.get_component(GameData.ComponentKeys.MELEE_COMBAT)
	var base_dam = caster_melee_combat_comp.calc_damage()
	var cast_weapon_element = caster_melee_combat_comp.get_element()

	var actual_damage_mod: float

	if cast_weapon_element == GameData.ELEMENT.PHYSICAL:
		actual_damage_mod = damage_mod
	elif cast_weapon_element == spell_node.spell_data.element:
		actual_damage_mod = damage_mod * 1.15
	else:
		actual_damage_mod = damage_mod * 0.85

	var dam = base_dam * actual_damage_mod
	return dam