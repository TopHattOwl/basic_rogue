class_name MeleeCombatComponent
extends Node

# base values for unarmed attack
# var damage: String = "1d4"
var damage: Array = [1, 4, []]
var attack_type: String = "bash"
var element: String = "physical"
var to_hit_bonus: int = 0


func initialize(d: Dictionary) -> void:
	damage = [d.get("num_of_dice", 1), d.get("dice_sides", 4), d.get("modifiers", [])]
	attack_type = d.get("attack_type", "bash")
	element = d.get("element", "physical")
	to_hit_bonus = d.get("to_hit_bonus", 0)

func get_dodge() -> int:
	var dodge = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES)).dexterity_modifier
	return dodge

# func get_to_hit_bonus() -> int:

# 	if get_parent().get_node(GameData.COMPONENTS[GameData.ComponentKeys.IDENTITY]).faction == "monsters":
# 		return get_parent().get_node(GameData.COMPONENTS[GameData.ComponentKeys.MONSTER_STATS]).to_hit_bonus

func get_armor() -> int:

	if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.IDENTITY)).faction == "monsters":
		return get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MONSTER_STATS)).armor


	var equipment  = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
	return equipment.get_total_armor()

## rolls the dice for damage, eturns randomly generated damage
func get_full_damage() -> int:
	var attributes = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES))

	# if monster, use it's damage
	if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.IDENTITY)).faction == "monsters":
		return Dice.roll_dice(damage)

	var equipment  = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))

	# if no weapon, just use base attack 
	if !equipment.weapon:
		return Dice.roll_dice(damage)

	var weapon_stats = equipment.get_weapn_stats()
	var weapon_damage = Dice.roll_damage_dice(weapon_stats.damage)
	weapon_damage += attributes.get_weapon_damage_bonus_from_scaling(weapon_stats.scaling)

	return weapon_damage
