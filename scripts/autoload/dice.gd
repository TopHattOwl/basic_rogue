extends Node

func roll_dice(dice: Array) -> int:
	var total := 0
	var num_of_dice: int = dice[0]
	var dice_sides: int = dice[1]
	var modifiers: Array = dice[2]

	# roll the dice
	for i in range(num_of_dice):
		total += randi_range(1, dice_sides)

	# add mods if it has any
	if modifiers:
		for mod in modifiers:
			total += mod

	return total

# func roll_dice(num_of_dice: int, sides: int, modifiers: Array = []) -> int:
# 	var total := 0
# 	for i in range(num_of_dice):
# 		total += randi_range(1, sides)
	
# 	if modifiers:
# 		for mod in modifiers:
# 			total += mod

# 	return total

func make_string(num_of_dice: int, sides: int, modifiers: Array = []) -> String:

	var mod_string := ""
	if modifiers:
		for mod in modifiers:
			if mod > 0:
				mod_string += "+"

			mod_string += str(mod)

	return str(num_of_dice) + "d" + str(sides) + mod_string

# old

func roll_damage_dice(dice_string: String) -> int:
	# Initialize variables
	var num_dice := 1
	var dice_sides := 6
	var modifier := 0
	
	# Split the string into main parts (dice and modifiers)
	var parts := dice_string.split("d", false, 1)
	if parts.size() != 2:
		return 0  # Invalid format
	
	# Parse number of dice
	num_dice = int(parts[0])
	
	# processe right side (dice sides and modifiers)
	var right_side := parts[1]

	# find where modifier starts
	var modifier_index = right_side.length()
	for chars in right_side:
		if chars == "+" or chars == "-":
			modifier_index = right_side.find(chars)
			break

	# extract dice sides
	dice_sides = int(right_side.substr(0, modifier_index))

	# process modifiers if there is any
	if modifier_index < right_side.length():
		var mod_string := right_side.substr(modifier_index)
		var current_sign := 1
		var current_num := ""
		
		for c in mod_string:
			if c == "+":
				if current_num != "":
					modifier += current_sign * int(current_num)
					current_num = ""
				current_sign = 1
			elif c == "-":
				if current_num != "":
					modifier += current_sign * int(current_num)
					current_num = ""
				current_sign = -1
			else:
				current_num += c
		
		# Add the last modifier
		if current_num != "":
			modifier += current_sign * int(current_num)
	
	# Roll the dice
	var total := 0
	for i in range(num_dice):
		total += randi_range(1, dice_sides)

	# Apply modifiers and ensure non-negative result
	return max(0, total + modifier)



func roll_dice_result(dice_string: String) -> int:
	var dice_data := parse_dice_string(dice_string)
	if dice_data.is_empty():
		return 0
	
	var base_roll = roll_dicee(dice_data.num_dice, dice_data.dice_sides)
	return max(0, base_roll + dice_data.modifier)

func parse_dice_string(dice_string: String) -> Dictionary:
	var components := _split_dice_components(dice_string)
	if components.is_empty():
		return {}
	
	return {
		"num_dice": components.num_dice,
		"dice_sides": components.dice_sides,
		"modifier": _calculate_modifier(components.modifier_string)
	}

func _split_dice_components(dice_string: String) -> Dictionary:
	var parts := dice_string.split("d", false, 1)
	if parts.size() != 2:
		return {}
	
	var num_dice := _parse_positive_int(parts[0])
	var right_side := parts[1]
	
	var modifier_index := _find_first_modifier_index(right_side)
	var dice_sides := _parse_positive_int(right_side.substr(0, modifier_index))
	var modifier_string := right_side.substr(modifier_index) if modifier_index < right_side.length() else ""
	
	return {
		"num_dice": num_dice,
		"dice_sides": dice_sides,
		"modifier_string": modifier_string
	}

func _find_first_modifier_index(input: String) -> int:
	for i in input.length():
		if input[i] in "+-":
			return i
	return input.length()

func _calculate_modifier(mod_string: String) -> int:
	var total := 0
	var current_sign := 1
	var current_num := ""
	
	# Handle leading numbers without explicit sign
	if not mod_string.is_empty() and mod_string[0].is_valid_int():
		mod_string = "+" + mod_string
	
	for c in mod_string:
		match c:
			"+":
				_apply_current_number(total, current_sign, current_num)
				current_sign = 1
				current_num = ""
			"-":
				_apply_current_number(total, current_sign, current_num)
				current_sign = -1
				current_num = ""
			_:
				current_num += c
	
	_apply_current_number(total, current_sign, current_num)
	return total

func _apply_current_number(_total: int, signn: int, num_str: String) -> void:
	if num_str.is_valid_int():
		# Use call_by_reference to modify original _total
		var num = int(num_str)
		_total += signn * num

func _parse_positive_int(input: String) -> int:
	return max(int(input) if input.is_valid_int() else 0, 0)

func roll_dicee(num_dice: int, dice_sides: int) -> int:
	var _total := 0
	for i in num_dice:
		_total += randi_range(1, max(dice_sides, 1))
	return _total
