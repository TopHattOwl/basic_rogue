class_name MeleeCombatComponent
extends Node

# --- these stats get modified when equiping stuff ---
# base damage stats
var damage_min: int = 0
var damage_max: int = 0
var attack_type: int = GameData.ATTACK_TYPE.BASH
var element: int = GameData.ELEMENT.PHYSICAL


# --- These stats don't get modified when equiping stuff ---
# calculated from dexterity
var accuracy: float = 0

# melee defensive stats 
var melee_dodge: float = 0 # chanche to dodge a melee attack
var melee_repost: float = 0

# melee offensive stats
var melee_crit_chance: float = 0
var melee_crit_damage: float = 1 

func initialize(d: Dictionary) -> void:
	damage_min = d.get("damage_min", 0)
	damage_max = d.get("damage_max", 0)
	attack_type = d.get("attack_type", 1)

	accuracy = d.get("accuracy", 0)

	element = d.get("element", 0)

	melee_dodge = d.get("melee_dodge", 0)

# combat system
func melee_attack(target: Node2D) -> bool:

	# get attacker and target position
	var attacker_pos: Vector2i = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.POSITION)).grid_pos
	var target_pos: Vector2i = ComponentRegistry.get_component(target, GameData.ComponentKeys.POSITION).grid_pos
	
	# dir used for animation
	var dir: Vector2i = target_pos - attacker_pos
	dir.clamp(Vector2i(-1, -1), Vector2i(1, 1))

	# get target health and melee cobat component
	var target_melee_combat = ComponentRegistry.get_component(target, GameData.ComponentKeys.MELEE_COMBAT)
	var target_health: HealthComponent = ComponentRegistry.get_component(target, GameData.ComponentKeys.HEALTH)
	if !target_melee_combat:
		# if no melee combat -> look for monster combat componenet
		target_melee_combat = ComponentRegistry.get_component(target, GameData.ComponentKeys.MONSTER_COMBAT)
		if !target_melee_combat:
			push_error("target has no melee combat component")
			return false
	if !target_health:
		push_error("target has no health component")
		return false

	# damage of the attack
	var dam: int = calc_damage()

	var signal_hit_data := {}

	# accuracy check against dodge
	var target_dodge = target_melee_combat.melee_dodge
	var hit_chance = clamp(accuracy - target_dodge, 0.05, 0.95)
	var roll = randf()
	if roll > hit_chance:
		# tried to hit but missed so actor acted
		signal_hit_data = {
			"target": target,
			"attacker": get_parent().get_parent(),
			"damage": 0,
			"direction": dir,
			"element": element,
			"hit_action": GameData.HIT_ACTIONS.MISS
		}
		SignalBus.actor_hit.emit(signal_hit_data)
		return true
	
	# no block check, monster's can't block only have armor
	

	# add skill xp for weapon if using weapon
	# add skill xp for element if used elemental attack

	signal_hit_data = {
		"target": target,
		"attacker": get_parent().get_parent(),
		"damage": dam,
		"direction": dir,
		"element": element,
		"hit_action": GameData.HIT_ACTIONS.HIT
	}
	SignalBus.actor_hit.emit(signal_hit_data)

	return true

# --- Utils ---

func get_armor() -> int:

	var equipment: EquipmentComponent  = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
	return equipment.get_total_armor()

func calc_damage() -> int:
	var dam := 0

	if get_parent().has_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)):
		var dam_min = int(ModifierSystem.get_modified_value(get_parent().get_parent(), "damage_min", GameData.ComponentKeys.MELEE_COMBAT))
		var dam_max = int(ModifierSystem.get_modified_value(get_parent().get_parent(), "damage_max", GameData.ComponentKeys.MELEE_COMBAT))
		dam = randi_range(dam_min, dam_max)
	else:
		# if no modifier component use base value
		dam = randi_range(damage_min, damage_max)

	return dam


func reset_to_unarmed() -> void:
	var damage = get_parent().get_parent().AttributesComp.strength / 2

	damage_min = damage * 0.9
	damage_max = damage * 1.1
	attack_type = GameData.ATTACK_TYPE.BASH
	element = GameData.ELEMENT.PHYSICAL
	
