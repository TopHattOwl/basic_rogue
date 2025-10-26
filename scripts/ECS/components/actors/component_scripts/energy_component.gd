class_name EnergyComponent
extends Node


@export var quickness: int = 1000:
	set(value):
		quickness = value
		energy = value

## Current energy accumulated
var energy: int = 0


## energy cost variables so modifier system can modify them

var move_cost: int = GameData.get_action_cost(GameData.ACTIONS.MOVE)
var melee_attack_cost: int = GameData.get_action_cost(GameData.ACTIONS.MELEE_ATTACK)
var ranged_attack_cost: int = GameData.get_action_cost(GameData.ACTIONS.RANGED_ATTACK)
var cast_spell_cost: int = GameData.get_action_cost(GameData.ACTIONS.CAST_SPELL)
var change_stance_cost: int = GameData.get_action_cost(GameData.ACTIONS.CHANGE_STANCE)


func initialize(data: Dictionary) -> void:
	quickness = data.get("quickness", 1000)

	# if no special starting energy, just max it
	energy = data.get("starting_energy", quickness)


## Gain energy each tick
func tick() -> void:
	var debug: bool = GameData.tick_debug
	if get_parent().get_parent() == GameData.player:
		if debug:
			print("[Energy component] ticking player, energy before: ", energy)
	else:
		if debug:
			print("[Energy component] ticking actor({0}), energy before: {1}".format([get_parent().get_parent().uid, energy]))
	if debug:
		print("[Energy component] quickness: ", quickness)
		print("[Energy component] actor ticked, energy after: ", energy)

	energy += quickness


## Spend energy after action, keeping remainder
func spend_energy(cost: int) -> void:
	energy -= cost


## for testing/debugging
func reset_energy() -> void:
	energy = 0
