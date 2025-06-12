class_name SingleTargetComponent
extends SpellComponent


## % of the melee combat component's calculated damage will be the damage of the spell
@export var damage_mod: float
@export var spell_range: int


func on_cast(_spell: SpellResource, _caster: Node2D, _target_grid: Variant = null) -> void:
    var target = GameData.get_actor(_target_grid)

    if null == target:
        return

    


    print("oncast function for single target")
    print("hitting target: ", target)

    