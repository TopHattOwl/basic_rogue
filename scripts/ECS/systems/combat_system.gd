class_name CombatSystem
extends Node

# this main_node variable is set in main_node.gd's ready function by entity-systems-manager.gd

func melee_attack(attacker: Node2D, target: Node2D) -> bool:
	if attacker == target:
		return false

	var attacker_melee_combat_component = ComponentRegistry.get_component(attacker, GameData.ComponentKeys.MELEE_COMBAT)
	var target_melee_combat_component = ComponentRegistry.get_component(target, GameData.ComponentKeys.MELEE_COMBAT)
	var target_health_component = ComponentRegistry.get_component(target, GameData.ComponentKeys.HEALTH)

	if !attacker_melee_combat_component:
		push_error("attacker has no melee combat component")
	if !target_melee_combat_component:
		push_error("target has no melee combat component")
	if !target_health_component:
		push_error("target has no health component")

	var accuracy_roll = Dice.roll_dice([1, 20, [attacker_melee_combat_component.to_hit_bonus]])

	if accuracy_roll < target_melee_combat_component.get_dodge():
		# tried to hit but missed so actor acted

		return true

	var damage_roll = attacker_melee_combat_component.get_full_damage()
	var final_damage = max(0, damage_roll - target_melee_combat_component.get_armor())

	target_health_component.take_damage(final_damage)
	

	return true

func die(actor: Node2D):

	var actor_pos = ComponentRegistry.get_component(actor, GameData.ComponentKeys.POSITION).grid_pos
	var actor_identity = ComponentRegistry.get_component(actor, GameData.ComponentKeys.IDENTITY)

	# delete actor from entity_map and all_hostle_actors
	GameData.actors_map[actor_pos.y][actor_pos.x] = null
	GameData.all_hostile_actors.erase(actor)
	GameData.all_actors.erase(actor)

	# if monster drop monster remains TODO also drom monster loot
	if actor_identity.faction == "monsters":
		var monster_id = ComponentRegistry.get_component(actor, GameData.ComponentKeys.MONSTER_STATS).monster_id
		var monster_remains = load(DirectoryPaths.monster1_remains_scene[monster_id]).instantiate()
		ComponentRegistry.get_component(monster_remains, GameData.ComponentKeys.POSITION).grid_pos = actor_pos
		monster_remains.position = MapFunction.to_world_pos(actor_pos)
		GameData.main_node.add_child(monster_remains)

	# remove actor
	actor.queue_free()
	



	
