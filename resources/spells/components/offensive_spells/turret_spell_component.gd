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
