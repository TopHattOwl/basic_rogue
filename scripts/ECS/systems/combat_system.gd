extends Node

func _ready() -> void:
	SignalBus.actor_hit.connect(_damage_actor)


func _damage_actor(hit_data: Dictionary) -> void:
	var debug = GameData.melee_combat_debug
	if debug:
		print("----- damageing actor -----")

	var target = hit_data.target
	var damage = hit_data.damage
	var element = hit_data.element

	var target_defense_comp = ComponentRegistry.get_component(target, GameData.ComponentKeys.DEFENSE_STATS)
	var target_health = ComponentRegistry.get_component(target, GameData.ComponentKeys.HEALTH)
	if !target_defense_comp:
		push_error("target, {0} has no defense component".format(ComponentRegistry.get_component(target, GameData.ComponentKeys.IDENTITY).actor_name))
		return
	if !target_health:
		push_error("target, {0} has no health component".format(ComponentRegistry.get_component(target, GameData.ComponentKeys.IDENTITY).actor_name))
		return
	
	var reduced_damage = target_defense_comp.calc_reduced_damage(damage, element)

	if debug:
		print("base damage: ", damage)
		print("reduced damage: ", reduced_damage)
		print("elemet: ", element)
		
	target_health.take_damage(reduced_damage)

	hit_data.damage = reduced_damage
	SignalBus.actor_hit_final.emit(hit_data)


# called from health component when entity dies
func die(actor: Node2D):

	var actor_pos = ComponentRegistry.get_component(actor, GameData.ComponentKeys.POSITION).grid_pos
	var actor_identity = ComponentRegistry.get_component(actor, GameData.ComponentKeys.IDENTITY)
	var is_actor_player = GameData.player == actor
	# delete actor from entity_map and all_hostle_actors
	GameData.actors_map[actor_pos.y][actor_pos.x] = null
	GameData.all_hostile_actors.erase(actor)
	GameData.all_actors.erase(actor)

	# if actor is not player, toggle walkable tile when dies
	if not is_actor_player:
		MapFunction.astar_toggle_walkable(actor_pos)

	# if monster drop monster remains TODO also drom monster loot
	if actor_identity.faction == "monsters":
		var monster_id = ComponentRegistry.get_component(actor, GameData.ComponentKeys.MONSTER_STATS).monster_id
		var monster_remains = load(DirectoryPaths.monster_remains_scene[monster_id]).instantiate()
		ComponentRegistry.get_component(monster_remains, GameData.ComponentKeys.POSITION).grid_pos = actor_pos
		monster_remains.position = MapFunction.to_world_pos(actor_pos)
		GameData.main_node.add_child(monster_remains)

	# remove actor
	actor.queue_free()
