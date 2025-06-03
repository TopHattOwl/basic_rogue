class_name MeleeCombatComponent
extends Node

# --- these stats get modified when equiping stuff ---
# base damage stats
var damage_min: int = 0
var damage_max: int = 0
var attack_type: int = GameData.ATTACK_TYPE.BASH
var element: int = GameData.ELEMENT.PHYSICAL
var element_weight: float = 0 # remove element weight


# --- These stats don't get modified when equiping stuff ---
# calculated from dexterity
var accuracy: float = 0


# melee defensive stats 
var melee_dodge: float = 0 # chanche to dodge a melee attack
var melee_block: float = 0 # chance to block a melee attack
var melee_repost: float = 0 # chance to do a repost attack after dodging or blocking  or getting hit by a melee attack


# melee offensive stats
var melee_crit_chance: float = 0
var melee_crit_damage: float = 1 

func initialize(d: Dictionary) -> void:
	damage_min = d.get("damage_min", 0)
	damage_max = d.get("damage_max", 0)
	attack_type = d.get("attack_type", 1)

	accuracy = d.get("accuracy", 0)

	element = d.get("element", 0)
	element_weight = d.get("element_weight", 0)

	melee_dodge = d.get("melee_dodge", 0)
	melee_block = d.get("melee_block", 0)

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

	# accuracy check against dodge
	var target_dodge = target_melee_combat.melee_dodge
	var hit_chance = clamp(accuracy - target_dodge, 0.05, 0.95)
	var roll = randf()
	if roll > hit_chance:
		UiFunc.log_player_attack(target, 0, element, GameData.HIT_ACTIONS.MISS)
		# tried to hit but missed so actor acted
		SignalBus.actor_hit.emit(target, get_parent().get_parent(), 0, dir, element, GameData.HIT_ACTIONS.MISS)
		return true
	
	# no block check, monster's can't block only have armor


	dam -= max(0, target_melee_combat.get_armor())
	dam = max(0, dam)
	target_health.take_damage(dam)


	# add skill xp for weapon if using weapon
	# add skill xp for element if used elemental attack
	if ComponentRegistry.get_component(get_parent().get_parent(), GameData.ComponentKeys.IDENTITY).actor_name == "player":
		UiFunc.log_player_attack(target, dam, element)

	SignalBus.actor_hit.emit(target, get_parent().get_parent(), dam, dir, element, GameData.HIT_ACTIONS.HIT)

	return true


# func melee_block() -> void:
# 	pass

# --- Utils ---

func get_armor() -> int:

	var equipment: EquipmentComponent  = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
	return equipment.get_total_armor()

func calc_damage() -> int:
	var dam := 0

	if get_parent().has_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)):
		var dam_min = int(ModifierSystem.get_modified_melee_combat_value(get_parent().get_parent(), "damage_min"))
		var dam_max = int(ModifierSystem.get_modified_melee_combat_value(get_parent().get_parent(), "damage_max"))
		dam = randi_range(dam_min, dam_max)
	else:
		# if no modifier component use base value
		dam = randi_range(damage_min, damage_max)

	return dam

	
