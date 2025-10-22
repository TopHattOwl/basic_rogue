# # ====================
# # rune_socket_component.gd
# # ====================
# class_name RuneSocketComponent
# extends ItemComponent

# @export var max_sockets: int = 0
# @export var socketed_runes: Array[ItemResource] = []

# func has_empty_socket() -> bool:
# 	return socketed_runes.size() < max_sockets

# func socket_rune(rune: ItemResource) -> bool:
# 	if not has_empty_socket():
# 		return false
	
# 	socketed_runes.append(rune)
# 	return true

# func remove_rune(index: int) -> ItemResource:
# 	if index >= 0 and index < socketed_runes.size():
# 		return socketed_runes.pop_at(index)
# 	return null

# func on_equip(_item: ItemResource, entity: Node2D) -> void:
# 	# Apply all socketed rune effects
# 	for rune in socketed_runes:
# 		var rune_effect = rune.get_component(RuneEffectComponent)
# 		if rune_effect:
# 			rune_effect.apply_effect(entity)

# func on_unequip(_item: ItemResource, entity: Node2D) -> void:
# 	# Remove all socketed rune effects
# 	for rune in socketed_runes:
# 		var rune_effect = rune.get_component(RuneEffectComponent)
# 		if rune_effect:
# 			rune_effect.remove_effect(entity)


# # ====================
# # rune_effect_component.gd
# # ====================
# class_name RuneEffectComponent
# extends ItemComponent

# @export var stat_bonuses: Array[StatModifier] = []
# @export var special_effects: Array[Dictionary] = [] # For more complex effects

# func apply_effect(entity: Node2D) -> void:
# 	var modifiers_comp = entity.ModifiersComp
# 	if not modifiers_comp:
# 		return
	
# 	for bonus in stat_bonuses:
# 		modifiers_comp.add_modifier(bonus)
	
# 	# Apply special effects
# 	for effect in special_effects:
# 		_apply_special_effect(entity, effect)

# func remove_effect(entity: Node2D) -> void:
# 	var modifiers_comp = entity.ModifiersComp
# 	if not modifiers_comp:
# 		return
	
# 	for bonus in stat_bonuses:
# 		modifiers_comp.remove_modifier(bonus)
	
# 	# Remove special effects
# 	for effect in special_effects:
# 		_remove_special_effect(entity, effect)

# func _apply_special_effect(entity: Node2D, effect: Dictionary) -> void:
# 	# Implement special effect application based on effect type
# 	match effect.get("type", ""):
# 		"lifesteal":
# 			# Add lifesteal property to entity
# 			pass
# 		"thorns":
# 			# Add thorns damage reflection
# 			pass
# 		"elemental_damage":
# 			# Add elemental damage to attacks
# 			pass

# func _remove_special_effect(entity: Node2D, effect: Dictionary) -> void:
# 	# Implement special effect removal
# 	pass


# # ====================
# # armor_component.gd
# # ====================
# class_name ArmorComponent
# extends ItemComponent

# @export var armor_value: int = 0
# @export var resistances: Dictionary = {} # {element: resistance_value}
# @export var bonuses: Array[StatModifier] = []

# func on_equip(_item: ItemResource, entity: Node2D) -> void:
# 	var defense_comp = entity.get_component(GameData.ComponentKeys.DEFENSE_STATS)
# 	if defense_comp:
# 		defense_comp.armor += armor_value
		
# 		# Apply resistances
# 		for element in resistances:
# 			if defense_comp.resistances.has(element):
# 				defense_comp.resistances[element] += resistances[element]
	
# 	# Apply stat bonuses
# 	var modifiers_comp = entity.ModifiersComp
# 	if modifiers_comp:
# 		for bonus in bonuses:
# 			modifiers_comp.add_modifier(bonus)

# func on_unequip(_item: ItemResource, entity: Node2D) -> void:
# 	var defense_comp = entity.get_component(GameData.ComponentKeys.DEFENSE_STATS)
# 	if defense_comp:
# 		defense_comp.armor -= armor_value
		
# 		# Remove resistances
# 		for element in resistances:
# 			if defense_comp.resistances.has(element):
# 				defense_comp.resistances[element] -= resistances[element]
	
# 	# Remove stat bonuses
# 	var modifiers_comp = entity.ModifiersComp
# 	if modifiers_comp:
# 		for bonus in bonuses:
# 			modifiers_comp.remove_modifier(bonus)


# # ====================
# # durability_component.gd
# # ====================
# class_name DurabilityComponent
# extends ItemComponent

# @export var max_durability: int = 100
# var current_durability: int

# func _init() -> void:
# 	current_durability = max_durability

# func damage_item(amount: int) -> void:
# 	current_durability = max(0, current_durability - amount)
	
# 	if current_durability == 0:
# 		_on_item_broken()

# func repair_item(amount: int) -> void:
# 	current_durability = min(max_durability, current_durability + amount)

# func get_durability_percentage() -> float:
# 	return float(current_durability) / float(max_durability)

# func _on_item_broken() -> void:
# 	# Emit signal or trigger item break behavior
# 	pass


# # ====================
# # consumable_component.gd
# # ====================
# class_name ConsumableComponent
# extends ItemComponent

# @export var use_type: int # INSTANT, OVER_TIME, etc.
# @export var cooldown: float = 0.0
# var cooldown_remaining: float = 0.0

# func on_use(_item: ItemResource, entity: Node2D, _target: Variant = null) -> void:
# 	if cooldown_remaining > 0:
# 		return
	
# 	cooldown_remaining = cooldown
	
# 	# Consumable usage is handled by other components (HealingComponent, etc.)
# 	# This just manages the cooldown


# # ====================
# # healing_component.gd
# # ====================
# class_name HealingComponent
# extends ItemComponent

# @export var heal_amount: int = 0
# @export var heal_type: int # HP, STAMINA, etc.

# func on_use(_item: ItemResource, entity: Node2D, _target: Variant = null) -> void:
# 	match heal_type:
# 		GameData.HEAL_TYPE.HP:
# 			var health_comp = entity.get_component(GameData.ComponentKeys.HEALTH)
# 			if health_comp:
# 				health_comp.heal(heal_amount)
		
# 		GameData.HEAL_TYPE.STAMINA:
# 			var stamina_comp = entity.get_component(GameData.ComponentKeys.STAMINA)
# 			if stamina_comp:
# 				stamina_comp.restore(heal_amount)


# # ====================
# # stackable_component.gd
# # ====================
# class_name StackableComponent
# extends ItemComponent

# @export var max_stack: int = 99
# @export var count: int = 1

# func add_to_stack(amount: int) -> int:
# 	var space_left = max_stack - count
# 	var amount_to_add = min(amount, space_left)
# 	count += amount_to_add
# 	return amount - amount_to_add # Returns overflow

# func remove_from_stack(amount: int) -> bool:
# 	if count >= amount:
# 		count -= amount
# 		return true
# 	return false

# func is_full() -> bool:
# 	return count >= max_stack

# func has_space() -> bool:
# 	return count < max_stack