class_name MeleeCombatComponent
extends Node

# --- these stats get modified when equiping stuff ---
# base damage stats
var damage_min: int = 0
var damage_max: int = 0
var attack_type: int = GameData.ATTACK_TYPE.BASH
var element: int = GameData.ELEMENT.PHYSICAL
var element_weight: float = 0 # remove element weight

var damage_min_offhand: int = 0
var damage_max_offhand: int = 0
var attack_type_offhand: int = GameData.ATTACK_TYPE.BASH
var element_offhand: int = GameData.ELEMENT.PHYSICAL


# --- These stats don't get modified when equiping stuff ---
# calculated from dexterity
var accuracy: float = 0


# melee defensive stats 
var melee_dodge: float = 0 # chanche to dodge a melee attack
var melee_block: float = 0 # chance to block a melee attack
var melee_repost: float = 0 # chance to do a repost attack after dodging or blocking a melee attack


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

	# accuracy check
	if randf() > accuracy:
		UiFunc.log_player_attack(target, 0, element, 1)
		# tried to hit but missed so actor acted
		AnimationSystem.play_attack_animation(get_parent().get_parent(), dir)
		return true
	
	# dodge check
	if randf() < target_melee_combat.melee_dodge:
		UiFunc.log_player_attack(target, 0, element, 2)
		# tried to hit but missed so actor acted
		AnimationSystem.play_attack_animation(get_parent().get_parent(), dir)
		return true 
	
	var dam: int = calc_damage()

	dam -= max(0, target_melee_combat.get_armor())
	target_health.take_damage(dam)


	# add skill xp for weapon if using weapon
	# add skill xp for element if used elemental attack
	if ComponentRegistry.get_component(get_parent().get_parent(), GameData.ComponentKeys.IDENTITY).actor_name == "player":
		UiFunc.log_player_attack(target, dam, element)
	
	AnimationSystem.play_attack_animation(get_parent().get_parent(), dir)

	SignalBus.actor_hit.emit(target, get_parent().get_parent(), dam, dir, element)

	return true

# --- Utils ---

func get_armor() -> int:

	if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.IDENTITY)).faction == "monsters":
		return get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MONSTER_STATS)).armor


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

	
