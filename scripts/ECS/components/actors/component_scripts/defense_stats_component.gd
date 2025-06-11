class_name DefenseStatsComponent
extends Node


## armor -> converted to percentage between 0% and 80% [br]
var armor: int

# elemental resists, percentage
var resistances: Dictionary = {
    GameData.ELEMENT.FIRE: 0.0,
    GameData.ELEMENT.ICE: 0.0,
    GameData.ELEMENT.LIGHTNING: 0.0,
    GameData.ELEMENT.BLOOD: 0.0,
    GameData.ELEMENT.POISON: 0.0,
}

func initialize(d: Dictionary) -> void:
    armor = d.get("armor", 0)
    resistances = d.get("resistances", {})


func calc_reduced_damage(damage: int, element: int) -> int:

    # if attack is physical, use armor
    if element == GameData.ELEMENT.PHYSICAL:
        var armor_percent = calc_armor_resistance()
        return int(damage * (1.0 - armor_percent))

    # if attack is not physical, use reduces armor value and resistance
    # armor also useful against elements somewhat
    else:
        # var armor_percent = calc_armor_resistance()
        var resist = resistances.get(element, 0.0)
        return int(damage * (1.0 - resist))


func calc_armor_resistance() -> float:
    var armor_float = float(armor)
    var armor_percent: float = armor_float / (armor_float + 100)


    return clamp(armor_percent, 0.0, 0.8)