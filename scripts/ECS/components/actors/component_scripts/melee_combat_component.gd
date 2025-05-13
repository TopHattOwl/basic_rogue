class_name MeleeCombatComponent
extends Node

# base values for unarmed attack
# var damage: String = "1d4"
var damage: Array = [1, 4, []]
var attack_type: int = 1
var element: int = 0
var to_hit_bonus: int = 0


func initialize(d: Dictionary) -> void:
	damage = d.get("damage", [1, 4, []])
	attack_type = d.get("attack_type", 1)
	element = d.get("element", 0)
	to_hit_bonus = d.get("to_hit_bonus", 0)

func update() -> void:

	if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT)).weapon:
		var weapon = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT)).weapon
		damage = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).damage
		attack_type = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).attack_type
		element = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).element
		to_hit_bonus = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).to_hit_bonus
	else:
		damage = [1, 4, []]
		attack_type = 1
		element = 0
		to_hit_bonus = 0
	


func get_dodge() -> int:
	var dodge = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES)).dexterity_modifier
	return dodge

# TODO: set_to_hit_bonus

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

	return Dice.roll_dice(damage)


