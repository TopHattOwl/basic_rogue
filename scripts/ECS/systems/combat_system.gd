class_name CombatSystem
extends Node



# called from health component
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
		var monster_remains = load(DirectoryPaths.monster1_remains_scene[monster_id]).instantiate()
		ComponentRegistry.get_component(monster_remains, GameData.ComponentKeys.POSITION).grid_pos = actor_pos
		monster_remains.position = MapFunction.to_world_pos(actor_pos)
		GameData.main_node.add_child(monster_remains)

	# remove actor
	actor.queue_free()
