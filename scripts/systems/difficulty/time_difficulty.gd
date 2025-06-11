extends Node
## Time Difficulty System [br]
## Stroes multipyers that increase overt time as GameTime progesses

var health_multiplier: float = 1.01
var damage_multiplier: float = 1.01


## time passed in number of month, years for difficulty 
var months_passed: int = 0
var years_passed: int = 0


func _ready() -> void:
	SignalBus.month_passed.connect(_on_month_passed)
	SignalBus.year_passed.connect(_on_year_passed)
	
func _on_month_passed() -> void:
	print("month passed")

	months_passed += 1
	# helth multiplier
	var x = months_passed

	x = -0.0000146503 * pow(x, 3) + 0.00202007 * pow(x, 2) + 0.033369 * x + 1.09487
	# x = pow(x, 2.97)
	health_multiplier = x

	# damage multiplier
	x = months_passed
	x = 3.421491522659 * pow(10, -6) * pow(x, 3) - 0.000378077 * pow(x, 2) + 0.0443807 * x + 0.923532
	damage_multiplier = x


	print("health multiplier: ", health_multiplier)
	print("damage multiplier: ", damage_multiplier)

func _on_year_passed() -> void:
	years_passed += 1
	print("year passed")
	health_multiplier += 0.1
	damage_multiplier += 0.1



## Calculates monster stats from time_difficulty [br]
## Modifies the node's value directly [br]
## Dict setup: `{"monster_combat_component": monster_combat_component}`
func calc_monster_stats(d: Dictionary, monster: Node2D) -> void:
	var modified_values := d

	var monster_combat_comp = d.get("monster_combat_component", {})
	var health_comp = d.get("health_component", {})


	if !monster_combat_comp or !health_comp:
		push_error("calc_monster_stats() - missing components for monster: ", ComponentRegistry.get_component(monster, GameData.ComponentKeys.IDENTITY).actor_name)
		return

	# DAMAGE
	# Damage min
	var base_damage_min = modified_values.monster_combat_component.damage_min
	var new_damage_min = int(base_damage_min * damage_multiplier)
	monster.monster_combat_component.damage_min = new_damage_min

	# Damage max
	var base_damage_max = modified_values.monster_combat_component.damage_max
	var new_damage_max = int(base_damage_max * damage_multiplier)
	monster.monster_combat_component.damage_max = new_damage_max
	

	# HEALTH
	var base_health = modified_values.health_component
	var new_health = int(base_health * health_multiplier)
	monster.max_hp = new_health
	 
	
