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
	
	if randf() < target_melee_combat.melee_dodge:
		print("%s dodged" % target.name)
		# tried to hit but missed so actor acted
		return true 
	
	var dam: Dictionary = calc_damage()

	dam[GameData.ELEMENT.PHYSICAL] -= max(0, target_melee_combat.get_armor())

	# if element damage implemented change 3 to 1
	if dam.size() > 3:
		# call element damage function here
		pass
	else:
		target_health.take_damage(dam[GameData.ELEMENT.PHYSICAL])


	if get_parent().get_parent().is_in_group("player"):
		pass
		# add skill xp for weapon if using weapon
		# add skill xp for element if used elemental attack

		UiFunc.log_message("You hit the %s for %s damage" % [target.name, dam[GameData.ELEMENT.PHYSICAL]])
	return true

# --- Utils ---

func get_dodge() -> int:
	var dodge = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES)).dexterity_modifier
	return dodge

func get_armor() -> int:

	if get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.IDENTITY)).faction == "monsters":
		return get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.MONSTER_STATS)).armor


	var equipment  = get_parent().get_node(GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT))
	return equipment.get_total_armor()


# need to implement this
func calc_damage() -> Dictionary:
	var full_damage = {}


	var dam = randi_range(damage_min, damage_max)

	# if melee attack has element deal elemental damage
	if !element == GameData.ELEMENT.PHYSICAL:
		var dam_physical = dam * (1 - element_weight)
		var dam_element = dam * element_weight

		full_damage[GameData.ELEMENT.PHYSICAL] = dam_physical
		full_damage[element] = dam_element
	else:
		full_damage[GameData.ELEMENT.PHYSICAL] = dam
	

	return full_damage
