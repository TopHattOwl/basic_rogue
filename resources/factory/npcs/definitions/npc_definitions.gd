extends Node


# making new npc:
	# add id and uid to GameData.NPCS_ALL and GameData.NPC_UIDS
	# add sprite path to DirectoryPaths.npc_sprites


var npc_definitions: Dictionary = {

	# ------------------------
	# || STATIC SPAWN NPCS  ||
	# ------------------------

	GameData.NPCS_ALL.WIZARD: {
		"base_data": {
			"id": GameData.NPCS_ALL.WIZARD,
			"uid": GameData.NPC_UIDS[GameData.NPCS_ALL.WIZARD],
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Wizard",
			"faction": "npcs",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 100,
		},

		GameData.get_component_name(GameData.ComponentKeys.QUEST_GIVER): {

		},

		GameData.get_component_name(GameData.ComponentKeys.TALK): {
			"conversation_tree_json_path": DirectoryPaths.npc_conversations_json[GameData.NPCS_ALL.WIZARD],
		},
	},

    # -----------------------------------------------------------------------------------

	GameData.NPCS_ALL.BLACKSMITH: {
		"base_data": {
			"id": GameData.NPCS_ALL.BLACKSMITH,
			"uid": GameData.NPC_UIDS[GameData.NPCS_ALL.BLACKSMITH],
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Blacksmith",
			"faction": "npcs",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 100,
		},

		GameData.get_component_name(GameData.ComponentKeys.TALK): {
			"conversation_tree_json_path": DirectoryPaths.npc_conversations_json[GameData.NPCS_ALL.BLACKSMITH],
		},

		GameData.get_component_name(GameData.ComponentKeys.SHOP_KEEPER): {
			
		},
	},

    # -----------------------------------------------------------------------------------

    
}
