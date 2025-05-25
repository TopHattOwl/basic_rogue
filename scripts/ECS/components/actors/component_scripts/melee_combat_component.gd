class_name MeleeCombatComponent
extends Node

var damage_min: int = 0
var damage_max: int = 0
var attack_type: int = 1

var accuracy: float = 0

var element: int = 0
var element_weight: float = 0

var melee_dodge: float = 0


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
		push_error("target has no melee combat component")
		return false
	if !target_health:
		push_error("target has no health component")
		return false

	# accuracy check
	if randf() > accuracy:
		print("%s missed" % get_parent().get_parent().name)
		# tried to hit but missed so actor acted
		return true
	
	# dodge check
	if randf() < target_melee_combat.melee_dodge:
		print("%s dodged" % target.name)
		# tried to hit but missed so actor acted
		return true 
	
	var dam: int = calc_damage()

	dam -= max(0, target_melee_combat.get_armor())
	target_health.take_damage(dam)


	if get_parent().get_parent().is_in_group("player"):
		pass
		# add skill xp for weapon if using weapon
		# add skill xp for element if used elemental attack

		UiFunc.log_message("You hit the %s for %s damage" % [target.name, dam])

	
	# animation goes here

	return true

# --- Utils ---

func get_armor() -> int:

	if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.IDENTITY)).faction == "monsters":
		return get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MONSTER_STATS)).armor


	var equipment  = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
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