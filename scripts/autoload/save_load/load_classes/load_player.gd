class_name LoadPlayer
# save_load.gd
extends Node


func load_player_data(json):
	# Position component
	var position = json.get("position_component")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos = Vector2i(position.get("grid_pos").get("x"), position.get("grid_pos").get("y"))

	# Health component
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).max_hp = json.get("health_component").get("max_hp")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).hp = json.get("health_component").get("hp")

	# Attributes component
	var attributes = json.get("attributes_component")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.ATTRIBUTES).strength = attributes.get("strength")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.ATTRIBUTES).dexterity = attributes.get("dexterity")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.ATTRIBUTES).intelligence = attributes.get("intelligence")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.ATTRIBUTES).constitution = attributes.get("constitution")

	# Identity component
	var identity = json.get("identity_component")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.IDENTITY).is_player = identity.get("is_player")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.IDENTITY).actor_name = identity.get("actor_name")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.IDENTITY).faction = identity.get("faction")

	# Player component
	var player = json.get("player_component")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_dungeon = player.get("is_in_dungeon")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = player.get("is_players_turn")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_in_world_map = player.get("is_in_world_map")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).world_map_pos = Vector2i(player.get("world_map_pos").get("x"), player.get("world_map_pos").get("y"))
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_dead = player.get("is_dead")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).input_mode = player.get("input_mode")

	# Melee combat component
	var melee = json.get("melee_combat_component")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).damage_min = melee.get("damage_min")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).damage_max = melee.get("damage_max")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).attack_type = melee.get("attack_type")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).accuracy = melee.get("accuracy")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).element = melee.get("element")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).element_weight = melee.get("element_weight")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).melee_dodge = melee.get("melee_dodge")

	# Skills component
	var skills = json.get("skills_component")
	var skill_levels = skills.get("skill_levels")
	var skill_levels_comp = ComponentRegistry.get_player_comp(GameData.ComponentKeys.SKILLS).skill_levels
	
	for skill_key in skill_levels.keys():
		skill_levels_comp[int(skill_key)] = skill_levels[skill_key]
