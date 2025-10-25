class_name MonsterDropsComponent
extends Node

const MAX_DROP_LOOP = 50


var loot_pool: Array = []
# array of dictionaries
# {
#		"item_id": item_id,
#		"weight": int,
#	 	"max_amount": int # max amount monster can drop of this item
# }

## what item(s) the monster drops 100% of the time
var fix_loot_pool: Array = []


var initial_drop_chance: float = 0.80
var drop_chance_multiplier: float = 0.65

func initialize(d: Dictionary) -> void:
	loot_pool = d.get("loot_pool", [])
	fix_loot_pool = d.get("fix_loot_pool", [])
	initial_drop_chance = d.get("initial_drop_chance", 0.80)
	drop_chance_multiplier = d.get("drop_chance_multiplier", 0.64)


func roll_drops() -> Array[int]:
	var drops: Array[int] = []

	if not fix_loot_pool.is_empty():
		drops.append_array(fix_loot_pool)

	var random_drops = _roll_for_drops()
	drops.append_array(random_drops)

	return drops

func _roll_for_drops() -> Array[int]:
	if loot_pool.is_empty():
		return []
	
	var dropped_items: Array[int] = []

	# duplicate the pool
	var working_pool: Array[Dictionary] = []
	for entry in loot_pool:
		working_pool.append(entry.duplicate())

	var current_drop_chance = initial_drop_chance

	var i = 0
	while not working_pool.is_empty():
		if randf() > current_drop_chance:
			break
		if i > MAX_DROP_LOOP:
			push_warning("[MonsterDropsComponent] MAX_DROP_LOOP limit reached")
			break
		
		var selected_item_id = _weighted_selection(working_pool)

		if selected_item_id == -1:
			break

		dropped_items.append(selected_item_id)
		_reduce_item_amount(working_pool, selected_item_id)

		current_drop_chance *= drop_chance_multiplier

		i += 1

	return dropped_items


func _weighted_selection(pool: Array[Dictionary]) -> int:
	if pool.is_empty():
		return -1
	
	# calc total weight
	var total_weight: float = 0.0
	for entry in pool:
		total_weight += entry.weight
	
	if total_weight <= 0:
		return -1
	
	# select random
	var random_value = randf() * total_weight
	var current_weight: float = 0.0
	
	for entry in pool:
		current_weight += entry.weight
		if random_value <= current_weight:
			return entry.item_id
	

	# fallback
	return pool[0].item_id


## Reduce max_amount for selected item from working loot pool, remove if depleted
func _reduce_item_amount(pool: Array[Dictionary], item_id: int) -> void:

	# iterates backwards
	for i in range(pool.size() - 1, -1, -1):
		if pool[i].item_id == item_id:
			pool[i].max_amount -= 1
			
			# remove from pool if depleted
			if pool[i].max_amount <= 0:
				pool.remove_at(i)
			
			return
