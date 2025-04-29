class_name LoadPlayer
# save_load.gd
extends Node


func load_player_data(json):
	# Position component
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos.x = json.get("position_component").get("grid_pos").get("x")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.POSITION).grid_pos.y = json.get("position_component").get("grid_pos").get("y")
	
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

	# Melee combat component
	var melee = json.get("melee_combat_component")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).damage = melee.get("damage")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).attack_type = melee.get("attack_type")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).element = melee.get("element")
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.MELEE_COMBAT).to_hit_bonus = melee.get("to_hit_bonus")