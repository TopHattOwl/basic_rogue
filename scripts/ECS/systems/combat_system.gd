extends Node

func _ready() -> void:
	SignalBus.actor_hit.connect(_damage_actor)


func _damage_actor(hit_data: Dictionary) -> void:

	# debug ---------------------
	var debug = GameData.combat_system_debug
	if debug:
		print("----- damaging actor -----")
		print("Attacker: ", hit_data.attacker.get_component(GameData.ComponentKeys.IDENTITY).actor_name)
		print("Target: ", hit_data.target.get_component(GameData.ComponentKeys.IDENTITY).actor_name)

		var hit_action = hit_data.get("hit_action", null)
		match hit_action:
			GameData.HIT_ACTIONS.HIT:
				hit_action = "Hit"
			GameData.HIT_ACTIONS.MISS:
				hit_action = "miss"
			GameData.HIT_ACTIONS.BLOCKED:
				hit_action = "blocked"
			_:
				pass
		print("Hit action: ", hit_action)
	# debug ---------------------

	var combat_type = hit_data.get("combat_type", GameData.COMBAT_TYPE.MELEE)

	var target = hit_data.get("target", null)
	var damage = hit_data.get("damage", 0)	
	var element = hit_data.get("element", GameData.ELEMENT.PHYSICAL)

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

	# edit hit data's damage
	hit_data.damage = reduced_damage
	# add combat type
	hit_data.combat_type = combat_type

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
		EntitySpawner.spawn_monster_remains(actor)


	# remove actor
	actor.queue_free()
