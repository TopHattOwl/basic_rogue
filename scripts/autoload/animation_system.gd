extends Node

const ATTACK_DURATION = 0.05

signal attack_animation_finished(entiy)

func _ready() -> void:
	SignalBus.actor_hit_final.connect(_on_actor_hit)
	SignalBus.skill_leveled_up.connect(_on_skill_leveled_up)


func _on_actor_hit(hit_data: Dictionary) -> void:
	floating_damage_text(hit_data.target, hit_data.attacker, hit_data.damage, hit_data.direction, hit_data.element, hit_data.hit_action)

	if hit_data.combat_type == GameData.COMBAT_TYPE.MELEE:
		play_attack_animation(hit_data.attacker, hit_data.direction)

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


# --- DAMAGE NUMMBERS ---
const DAMAGE_TEXT_SCENE = preload(DirectoryPaths.damage_text_scene)
const ARCH_HEIGHT = GameData.TILE_SIZE.y / 1.2
const DURATION = 0.3

func floating_damage_text(target: Node2D, _attacker: Node2D, damage: int, direction: Vector2i, element: int, hit_action: int) -> void:

	if not is_instance_valid(target):
		return

	var damage_text = DAMAGE_TEXT_SCENE.instantiate()
	get_tree().current_scene.add_child(damage_text)
	
	# position above target
	var target_center = target.position - Vector2(damage_text.size.x / 2, damage_text.size.y / 2)
	var spawn_pos = target_center + Vector2(direction.x * GameData.TILE_SIZE.x / 2, direction.y * GameData.TILE_SIZE.y / 2)

	damage_text.position = spawn_pos

	# configure text
	match hit_action:
		GameData.HIT_ACTIONS.HIT: # hit
			damage_text.text = str(damage)
			damage_text.modulate = _get_element_color(element)
		GameData.HIT_ACTIONS.MISS:
			damage_text.text = "Miss"
			damage_text.modulate = "#bbbab5"
		GameData.HIT_ACTIONS.BLOCKED:
			damage_text.text = "Blocked"
			damage_text.modulate = "#bbbab5"

	# modifiy and clamp font size
	var base_size = 16
	var scaled_size = base_size * (1.0 + damage * 0.03)
	damage_text.label_settings = LabelSettings.new()
	damage_text.label_settings.font_size = clamp(scaled_size, 8, 30)
	damage_text.z_index = 100
	damage_text.z_as_relative = false


	# animate
	animate_damage_text(damage_text, direction, spawn_pos)


func animate_damage_text(damage_text: Label, direction: Vector2i, start_pos: Vector2) -> void:
	# tween
	var tween = get_tree().current_scene.create_tween()
	tween.set_parallel(false)

	# arch movement
	tween.tween_method(
		func(progress: float):
			var curve = progress * (1.0 - progress) * 4.0 # Quadratic curve
			var height_offset = Vector2(0, -curve * ARCH_HEIGHT)
			var horizontal_offset = Vector2(direction) * progress * 32.0
			damage_text.position = start_pos + height_offset + horizontal_offset,
		0.0, 1.0, DURATION
	)

	tween.tween_property(damage_text, "modulate:a", 0.0, DURATION)
	tween.tween_callback(damage_text.queue_free)



# func _get_arch_offset(dir: Vector2i) -> Vector2:
# 	var offset = Vector2.ZERO
# 	offset.x = dir.x * GameData.TILE_SIZE.x * 2
# 	offset.y = dir.y * GameData.TILE_SIZE.y * 1.5

# 	# adjust for diagonal
# 	if dir.x != 0 and dir.y != 0:
# 		offset *= 0.7071 # 1/sqrt(2) for normalization

# 	return offset

# --- LEVEL UP ANIMATION ---

func _on_skill_leveled_up(skill_id: int):
	var player_pos = ComponentRegistry.get_player_pos()

	var particles = load("res://resources/particles/level_up_particle.tscn").instantiate()

	particles.global_position = MapFunction.to_world_pos(player_pos)
	GameData.main_node.add_child(particles)


func _on_level_up():
	print("Player gained a real level")


func _get_element_color(element: int) -> String:
	match element:
		GameData.ELEMENT.PHYSICAL:
			return "#bbbab5"
		GameData.ELEMENT.FIRE:
			return "#a62121"
		GameData.ELEMENT.ICE:
			return "#56dcb4"
		GameData.ELEMENT.LIGHTNING:
			return "#dee310"
		GameData.ELEMENT.BLOOD:
			return "#591e18"
		GameData.ELEMENT.POISON:
			return "#2e610f"
		_:
			return "#bbbab5"


