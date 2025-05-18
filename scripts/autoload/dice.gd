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