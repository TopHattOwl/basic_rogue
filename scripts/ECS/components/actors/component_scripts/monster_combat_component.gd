class_name MonsterCombatComponent
extends Node

var damage_min: int = 0
var damage_max: int = 0
var attack_type: int = 1

var accuracy: float = 0

var element: int = 0
var element_weight: float = 0

# melee defensive stats 
var melee_dodge: float = 0 # chanche to dodge a melee attack
var melee_repost: float = 0 # chance to do a repost attack after dodging or blocking a melee attack

func initialize(d: Dictionary) -> void:
	damage_min = d.get("damage_min", 0)
	damage_max = d.get("damage_max", 0)
	attack_type = d.get("attack_type", 1)

	accuracy = d.get("accuracy", 0)

	element = d.get("element", 0)
	element_weight = d.get("element_weight", 0)

	melee_dodge = d.get("melee_dodge", 0)

func update() -> void:
	pass
	# if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT)).weapon:
	# 	var weapon = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT)).weapon
	# 	damage = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).damage
	# 	attack_type = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).attack_type
	# 	element = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).element
	# 	to_hit_bonus = ComponentRegistry.get_component(weapon, GameData.ComponentKeys.WEAPON_STATS).to_hit_bonus
	# else:
	# 	damage = [1, 4, []]
	# 	attack_type = 1
	# 	element = 0
	# 	to_hit_bonus = 0


# combat system
func melee_attack(target: Node2D) -> bool:
	var attacker_pos = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.POSITION)).grid_pos
	var target_pos = ComponentRegistry.get_component(target, GameData.ComponentKeys.POSITION).grid_pos
	
	# dir used for animation
	var dir: Vector2i = target_pos - attacker_pos


	var target_melee_combat = ComponentRegistry.get_component(target, GameData.ComponentKeys.MELEE_COMBAT)
	var target_health = ComponentRegistry.get_component(target, GameData.ComponentKeys.HEALTH)
	if !target_melee_combat:
		# if no melee combat -> look for monster combat componenet
		target_melee_combat = ComponentRegistry.get_component(target, GameData.ComponentKeys.MONSTER_COMBAT)
		if !target_melee_combat:
			push_error("target has no melee combat component")
			return false
	if !target_health:
		push_error("target has no health component")
		return false

	var dam: int = calc_damage()

	# accuracy check against dodge
	var target_dodge = target_melee_combat.melee_dodge
	var hit_chance = clamp(accuracy - target_dodge, 0.05, 0.95)
	var roll = randf()
	if roll > hit_chance:
		UiFunc.log_monster_attack(get_parent().get_parent(), 0, GameData.HIT_ACTIONS.MISS)
		# tried to hit but missed so actor acted
		SignalBus.actor_hit.emit(target, get_parent().get_parent(), 0, dir, element, GameData.HIT_ACTIONS.MISS)
		return true
	
	# block check
	var target_block_comp = ComponentRegistry.get_component(target, GameData.ComponentKeys.BLOCK)
	if target_block_comp.try_block(dam):
		UiFunc.log_monster_attack(get_parent().get_parent(), 0, GameData.HIT_ACTIONS.BLOCKED)
		# tried to hit but missed so actor acted
		SignalBus.actor_hit.emit(target, get_parent().get_parent(), 0, dir, element, GameData.HIT_ACTIONS.BLOCKED)
		return true 
	
	

	dam -= max(0, target_melee_combat.get_armor())
	target_health.take_damage(dam)

	UiFunc.log_monster_attack(get_parent().get_parent(), dam)

	SignalBus.actor_hit.emit(target, get_parent().get_parent(), dam, dir, element, GameData.HIT_ACTIONS.HIT)

	return true

# --- Utils ---

func get_armor() -> int:
	return get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MONSTER_STATS)).armor


func calc_damage() -> int:
	var dam := 0

	if get_parent().has_node(GameData.get_component_name(GameData.ComponentKeys.MODIFIERS)):
		var dam_min = int(ModifierSystem.get_modified_monster_melee_combat_value(get_parent().get_parent(), "damage_min"))
		var dam_max = int(ModifierSystem.get_modified_monster_melee_combat_value(get_parent().get_parent(), "damage_max"))
		dam = randi_range(dam_min, dam_max)
	else:
		# if no modifier component use base value
		dam = randi_range(damage_min, damage_max)

	return dam
