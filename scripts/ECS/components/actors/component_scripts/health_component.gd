class_name HealthComponent
extends Node

var max_hp: int = 10:
	set(value):
		max_hp = max(1, value)
var hp: int = 10:
	set(value):
		hp = clampi(value, 0, max_hp)



func initialize(max_hp_value: int) -> void:
	max_hp = max_hp_value
	hp = max_hp

func take_damage(damage: int) -> int:
	var actual_damage = min(damage, hp)
	hp -= actual_damage

	# floating damage text
	damage_float_text(actual_damage)

	if hp <= 0:
		EntitySystems.combat_system.die(get_parent().get_parent())
	return actual_damage


func heal(amount: int) -> int:
	var actual_heal = min(amount, max_hp - hp)
	hp += actual_heal
	return actual_heal


func damage_float_text(value: int):
	var color
	var entity = get_parent().get_parent()
	var is_player = entity.is_in_group("player")

	var number = Label.new()
	number.text = str(value)
	number.z_index = 7
	var offset = Vector2(GameData.TILE_SIZE.x / 2, GameData.TILE_SIZE.y)
	number.position = get_parent().get_parent().position - offset
	print("position origin: ", get_parent().get_parent().position)

	number.label_settings = LabelSettings.new()
	if is_player:
		color = "#bbbab5" # if player is hit base color is gray
	elif get_parent().get_parent().is_in_group("monsters"):
		color = "#a62121" # if monster is hit base color is red


	number.label_settings.font_color = color
	number.label_settings.font_size = 20
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size / 2)

	var tween = get_tree().create_tween()
	tween.tween_property(number, "position:y", number.position.y - 24, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "position:y", number.position.y, 0.2).set_ease(Tween.EASE_IN).set_delay(0.1)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN).set_delay(0.2)


	await tween.finished
	number.queue_free()





# ___________________________
# not working properly, fix it


# func damage_float_text_alt(value: int):
# 	# Create a dedicated node for the floating text
# 	var float_node = Node2D.new()
# 	float_node.name = "DamageFloatText"
	
# 	# Create and configure label
# 	var number = Label.new()
# 	number.text = str(value)
# 	number.z_index = 7
	
# 	# Determine color based on entity group
# 	var entity = get_parent().get_parent()
# 	if entity.is_in_group("player"):
# 		number.label_settings = _create_label_settings("#bbbab5")
# 	elif entity.is_in_group("monsters"):
# 		number.label_settings = _create_label_settings("#a62121")
	
# 	# Add to scene with proper parenting
# 	float_node.add_child(number)
# 	get_tree().root.add_child(float_node)
	
# 	# Position at entity's global position
# 	float_node.global_position = entity.global_position - Vector2(GameData.TILE_SIZE.x / 2, GameData.TILE_SIZE.y)
	
# 	# Start animation sequence
# 	_animate_damage_text(float_node, number)

# func _create_label_settings(color: String) -> LabelSettings:
# 	var settings = LabelSettings.new()
# 	settings.font_color = Color(color)
# 	settings.font_size = 20
# 	settings.outline_color = Color("#000")
# 	settings.outline_size = 1
# 	return settings

# func _animate_damage_text(float_node: Node2D, label: Label):
# 	# Wait until label is properly sized
# 	await float_node.get_tree().process_frame
	
# 	# Center pivot point
# 	label.pivot_offset = label.size / 2
	
# 	# Create tween bound to the float node
# 	var tween = float_node.create_tween().set_parallel(true)
	
# 	# Random arch movement (horizontal spread)
# 	var horizontal_spread = randf_range(-20, 20)
# 	var vertical_arch = -48
	
# 	tween.tween_property(float_node, "position:y", float_node.position.y + vertical_arch, 0.2).set_ease(Tween.EASE_OUT)
# 	tween.tween_property(float_node, "position:x", float_node.position.x + horizontal_spread, 0.2).set_ease(Tween.EASE_OUT)
	
# 	# Scale animation
# 	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.2).set_ease(Tween.EASE_OUT)
# 	tween.chain().tween_property(label, "scale", Vector2(0.8, 0.8), 0.2).set_ease(Tween.EASE_IN)
	
# 	# Fade out
# 	tween.chain().tween_property(label, "modulate:a", 0.0, 0.2)
	
# 	# Cleanup after animation
# 	tween.finished.connect(func(): 
# 		float_node.queue_free()
# 	)







# # Add this at the top of your script
# var active_float_positions = {}
# const MIN_DISTANCE = 16  # Minimum distance between damage texts

# func damage_float_textt(value: int):
# 	# ... [previous setup code] ...
	
# 	# Find non-overlapping position
# 	var base_position = entity.global_position - Vector2(GameData.TILE_SIZE.x / 2, GameData.TILE_SIZE.y)
# 	float_node.global_position = _find_non_overlapping_position(base_position)
	
# 	# Register position
# 	var key = str(Time.get_ticks_msec())
# 	active_float_positions[key] = float_node.position
# 	tween.finished.connect(func(): active_float_positions.erase(key), CONNECT_ONE_SHOT)
	
# 	# ... [animation code] ...

# func _find_non_overlapping_position(base_position: Vector2) -> Vector2:
# 	var position = base_position
# 	var attempts = 0
	
# 	# Check for nearby damage texts
# 	while attempts < 10:
# 		var overlapping = false
		
# 		for existing in active_float_positions.values():
# 			if position.distance_to(existing) < MIN_DISTANCE:
# 				overlapping = true
# 				break
				
# 		if not overlapping:
# 			return position
			
# 		# Try a new position
# 		position = base_position + Vector2(
# 			randf_range(-MIN_DISTANCE, MIN_DISTANCE),
# 			randf_range(-MIN_DISTANCE, MIN_DISTANCE)
# 		)
# 		attempts += 1
	
# 	return base_position  # Fallback

