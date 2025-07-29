extends Node
## Time Difficulty System [br]
## Stroes multipyers that increase overt time as GameTime progesses

var health_multiplier: float = 1.01
var damage_multiplier: float = 1.01

# calculation not yet implemented
var ambush_money_multiplier: float = 1.01
var ambush_chance_multiplier: float = 1.01

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
## returns the modified Dictionary [br]
func calc_monster_stats(d: Dictionary) -> Dictionary:

	var modified_values := d

	# monster combat
	var base_damage_min = modified_values.monster_combat_component.damage_min
	var new_damage_min = int(base_damage_min * damage_multiplier)
	modified_values.monster_combat_component.damage_min = new_damage_min

	var base_damage_max = modified_values.monster_combat_component.damage_max
	var new_damage_max = int(base_damage_max * damage_multiplier)
	modified_values.monster_combat_component.damage_max = new_damage_max


	# health
	var base_health = modified_values.health_component.max_hp
	var new_health = int(base_health * health_multiplier)
	modified_values.health_component.max_hp = new_health	

	return modified_values
