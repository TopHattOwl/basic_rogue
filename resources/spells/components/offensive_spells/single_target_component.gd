class_name SingleTargetComponent
extends SpellComponent


## % of the melee combat component's calculated damage will be the damage of the spell
@export var damage_mod: float
@export var spell_range: int

## speed in tiles per second
@export var speed: int


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