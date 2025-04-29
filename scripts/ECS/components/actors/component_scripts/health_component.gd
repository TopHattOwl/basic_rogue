class_name HealthComponent
extends Node

var max_hp: int = 10:
    set(value):
        max_hp = max(1, value)
var hp: int = 10:
    set(value):
        hp = clamp(value, 0, max_hp)



func initialize(max_hp_value: int) -> void:
    max_hp = max_hp_value
    hp = max_hp

func take_damage(damage: int) -> int:
    var actual_damage = min(damage, hp)
    hp -= actual_damage
    print(hp)
    if hp <= 0:
        EntitySystems.combat_system.die(get_parent().get_parent())
    return actual_damage


func heal(amount: int) -> int:
    var actual_heal = min(amount, max_hp - hp)
    hp += actual_heal
    return actual_heal
