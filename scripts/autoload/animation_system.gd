extends Node

const ATTACK_DURATION = 0.05

signal attack_animation_finished(entiy)

func _ready() -> void:
	SignalBus.actor_hit.connect(_on_actor_hit)


func _on_actor_hit(target: Node2D, attacker: Node2D, damage: int, direction: Vector2i, element: int) -> void:
	floating_damage_text(target, attacker, damage, direction, element)

	# play_attack_animation(attacker, direction)
	# maybe put attack animation here as well

# --- ATTACK ANIMATION ---
func play_attack_animation(entity: Node2D, direction: Vector2i) -> void:
	var dir = Vector2(direction.x, direction.y)
	var offset = dir * Vector2(GameData.TILE_SIZE.x / 2, GameData.TILE_SIZE.y / 2)

	var entity_sprite = entity.get_node("Sprite2D")

	# tween
	var tween = create_tween().set_parallel(false)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)


	# attack lunge
	tween.tween_property(entity_sprite, "position", offset, ATTACK_DURATION)

	# return to original pos
	tween.tween_property(entity_sprite, "position", Vector2.ZERO, ATTACK_DURATION)

	# completion signal
	tween.finished.connect(_on_attack_animation_finished.bind(entity))

func _on_attack_animation_finished(entity: Node2D):
	attack_animation_finished.emit(entity)


# --- DAMAGE NUMMBERS ---
const DAMAGE_TEXT_SCENE = preload(DirectoryPaths.damage_text_scene)

func floating_damage_text(target: Node2D, attacker: Node2D, damage: int, direction: Vector2i, element: int) -> void:
	print(target, attacker, damage, direction, element)

	if not is_instance_valid(target):
		return

	var damage_text = DAMAGE_TEXT_SCENE.instantiate()
	get_tree().current_scene.add_child(damage_text)
	
	# position above target
	var spawn_pos = target.globat_position + Vector2()





# deepseek said so:


# 1. Animation system implementation:
# animation_system.gd
# extends Node

# const DAMAGE_TEXT_SCENE = preload("res://ui/damage_text.tscn")

# func _ready() -> void:
#     SignalBus.actor_hit.connect(_on_actor_hit)

# func _on_actor_hit(target: Node2D, _attacker: Node2D, damage: int, 
#                  direction: Vector2, element: String):
#     spawn_damage_numbers(target, damage, element, direction)

# func spawn_damage_numbers(target: Node2D, damage: int, element: String, 
#                          direction: Vector2 = Vector2.ZERO):
#     if not is_instance_valid(target):
#         return
    
#     var damage_text = DAMAGE_TEXT_SCENE.instantiate()
#     get_tree().current_scene.add_child(damage_text)
    
#     # Position above target with direction offset
#     var spawn_pos = target.global_position
#     damage_text.global_position = spawn_pos + direction * 8
    
#     # Configure text
#     damage_text.text = str(damage)
#     damage_text.modulate = _get_element_color(element)
    
#     # Animate
#     var tween = damage_text.get_node("Tween")
#     tween.set_parallel()
#     tween.tween_property(damage_text, "position:y", 
#                         damage_text.position.y - 32, 0.5)
#     tween.tween_property(damage_text, "modulate:a", 0.0, 0.5)
#     tween.tween_callback(damage_text.queue_free).set_delay(0.5)

# func _get_element_color(element: String) -> Color:
#     match element:
#         "fire": return Color(1, 0.3, 0.1)
#         "ice": return Color(0.3, 0.7, 1)
#         "poison": return Color(0.5, 0.2, 1)
#         _: return Color(1, 1, 1)



# 2. Signal Emission Example (Combat System)

# # combat_system.gd
# func apply_damage(target: Entity, attacker: Entity, damage: int, 
#                  element: String = "physical"):
#     # Calculate attack direction
#     var attack_dir = (target.position - attacker.position).normalized()
    
#     # Emit signal with all parameters
#     SignalBus.actor_hit.emit(
#         target,    # Node2D reference
#         attacker,  # Node2D reference
#         damage,    # int
#         attack_dir,# Vector2
#         element    # String
#     )
    
#     # Apply actual damage
#     target.health_component.take_damage(damage)



# Key Features:
# 1. Direction-Based Positioning
# 	Damage text spawns in attack direction:
# 	spawn_pos + direction * 8

# 2. Element-Specific Coloring
# 	Different colors for damage types using _get_element_color()

# 3. Floating Animation
# 	Tween moves text upward while fading out

# 4. Automatic Cleanup
# 	queue_free() called after animation completes


# Enhanced version with advanced features:
# func spawn_damage_numbers(target: Node2D, damage: int, element: String, 
#                          direction: Vector2 = Vector2.ZERO):
#     # ... [previous setup] ...
    
#     # Critical hit effect
#     if damage >= 10:  # Example threshold
#         damage_text.scale = Vector2(1.5, 1.5)
#         damage_text.modulate = Color(1, 0.9, 0)
#         damage_text.text += "!"
        
#         # Add shake effect
#         var shake = ShakeEffect.new()
#         damage_text.add_child(shake)
#         shake.start(0.3, 4)
    
#     # Healing effect
#     if damage < 0:
#         damage_text.text = "+" + str(abs(damage))
#         damage_text.modulate = Color(0.2, 1, 0.3)
#         damage_text.position.y -= 24  # Start higher
    
#     # ... [tween animation] ...


# Additional 

# 1. Screen Shake Integration
# Add subtle screen shake for large damage:

# if damage > 20:
#     CameraSystem.add_trauma(0.3)

# 2. fonst sizing

# var font_size = clamp(damage / 5, 12, 36)
# damage_text.label_settings.font_size = font_size


# 3. sound

# AudioSystem.play_sound(_get_element_sound(element))