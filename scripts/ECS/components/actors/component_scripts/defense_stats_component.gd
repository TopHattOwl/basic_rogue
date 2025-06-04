class_name DefenseStatsComponent
extends Node


# armor for physical resistance
var armor: int = 0

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
    if element == GameData.ELEMENT.PHYSICAL:
        var armor_percent = calc_armor_resistance(damage)
        return int(damage * (1.0 - armor_percent))
    else:
        var resist = resistances.get(element, 0.0)
        return int(damage * (1.0 - resist))


func calc_armor_resistance(dam: int) -> float:
    var armor_percent: float = armor / (armor + 100)

    return armor_percent