class_name TurretSpellComponent
extends SpellComponent


## % of the melee combat component's calculated damage will be the base damage for
## the turret spell's projectiles damage calculation
@export var damage_mod: float
@export var spell_range: int

## speed in tiles per second
@export var speed: int

## the spell this turret will cast
@export var turret_spell_scene: PackedScene

## turret will cast a projectile for each enemy
## but only one for each enemy [br]
## No more than max_projectile_amount
@export var max_projectile_amount: int

## cooldown between shots in turns
@export var cooldown: int


## duration in turns for how long the turret spell remains
@export var duration: int


func cast_projectile() -> void:
    print("casting turret spell projectiles")



## calculates the turret spells base damage [br]
## and sets the variable as well
func calc_base_damage(spell_node: SpellNode) -> void:
    var caster_melee_combat_comp: MeleeCombatComponent = spell_node.caster.get_component(GameData.ComponentKeys.MELEE_COMBAT)
    var base_dam = caster_melee_combat_comp.calc_damage()
    var cast_weapon_element = caster_melee_combat_comp.get_element()


    # set TurretSpellNode's base damage variable  
    if cast_weapon_element == GameData.ELEMENT.PHYSICAL:
        spell_node.base_damage = base_dam
    elif cast_weapon_element == spell_node.spell_data.element:
        spell_node.base_damage = base_dam * 1.15
    else:    
        spell_node.base_damage = base_dam * 0.85
    