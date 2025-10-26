class_name EnergyComponent
extends Node


@export var quickness: int = 1000:
	set(value):
		quickness = value
		energy = value

## Current energy accumulated
var energy: int = 0

## Energy required to take an action
const ENERGY_THRESHOLD: int = 1000


func initialize(data: Dictionary) -> void:
	quickness = data.get("quickness", 1000)

	# if no special starting energy, just max it
	energy = data.get("starting_energy", quickness)


## Gain energy each tick
func tick() -> void:
	if get_parent().get_parent() == GameData.player:
		print("[Energy component] ticking player, energy before: ", energy)
	else:
		print("[Energy component] ticking actor({0}), energy before: {1}".format([get_parent().get_parent().uid, energy]))
	print("[Energy component] quickness: ", quickness)
	energy += quickness
	print("[Energy component] actor ticked, energy after: ", energy)

## Check if entity can act
func can_act() -> bool:
	return energy >= ENERGY_THRESHOLD


## Spend energy after action, keeping remainder
func spend_energy(cost: int) -> void:
	energy -= cost


## for testing/debugging
func reset_energy() -> void:
	energy = 0

## Get debug info
func get_debug_info() -> String:
	return "Energy: %d | quickness: %d | Can act: %s" % [energy, quickness, can_act()]