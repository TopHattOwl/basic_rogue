class_name HealthComponent
extends Node

var max_hp: int = 10:
	set(value):
		max_hp = max(1, value)
var hp: int = 10:
	set(value):
		hp = clampi(value, 0, max_hp)
		if get_parent().get_parent() == GameData.player:
			SignalBus.player_hp_changed.emit(hp, max_hp)


# func initialize2(max_hp_value: int) -> void:
# 	max_hp = max_hp_value
# 	hp = max_hp

func initialize(d: Dictionary) -> void:
	var _max_hp = d.get("max_hp", {})
	max_hp = _max_hp
	hp = max_hp

func take_damage(damage: int) -> int:
	var actual_damage = min(damage, hp)
	hp -= actual_damage

	if hp <= 0:
		CombatSystem.die(get_parent().get_parent())
	return actual_damage


func heal(amount: int) -> int:
	var actual_heal = min(amount, max_hp - hp)
	hp += actual_heal
	return actual_heal
