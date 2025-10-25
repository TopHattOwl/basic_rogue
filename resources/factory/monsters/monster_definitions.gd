extends Node

enum MONSTER_TYPES { NORMAL, MINIBOSS, BOSS }

# making new monster:
	# add monster id to GameData.MONSTERS_ALL
	# add uid to GameData.MONSTER_UIDS
	# add remains and sprite path to DirectoryPaths.monster_sprites and monster_remains_sprites
	# add monster data here to monster_definitions


# Cost calculation:
	# Normal monster:
		# 5 - 20
	# Miniboss:
		# 21 - 45
	# Boss:
		# 46 - 100


## Returns a Dict with all avalible monsters for a given biome [br]
## Dictionary setup: [br]
## `{monster_id: {monster base data} }` see MonsterDefinitions for base_data setup
func get_avalible_monsters(biome: int) -> Dictionary:
	var ids = {}
	

	for monster_id in monster_definitions:
		var biome_weights = monster_definitions[monster_id]["base_data"]["biome_weights"]
		var biomes = biome_weights.keys()
		if not biomes.has(biome):
			continue

		ids[int(monster_id)] = monster_definitions[monster_id]["base_data"]
	return ids

var monster_definitions: Dictionary = {
	# ------------------------------------
	# ||		NORMAL MONSTERS     	||
	# ------------------------------------
	GameData.MONSTERS_ALL.IRON_WORM: {
		"base_data": {
			"type": MONSTER_TYPES.NORMAL, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.IRON_WORM,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.IRON_WORM],
			"cost": 8,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FOREST: 0.8,
				GameData.WORLD_TILE_TYPES.FIELD: 0.4,
				},
			"monster_group": 1,
			"text_color": "#dfdfdf",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Iron Worm",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 78,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 10,
			"damage_max": 18,
			"attack_type": GameData.ATTACK_TYPE.BASH,
			"accuracy": 0.8,
			"element": GameData.ELEMENT.PHYSICAL,
			"melee_dodge": 0.05,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 43,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.05,
				GameData.ELEMENT.ICE: 0.05,
				GameData.ELEMENT.LIGHTNING: 0.05,
				GameData.ELEMENT.BLOOD: 0.05,
				GameData.ELEMENT.POISON: 0.05,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 13,
			"dexterity": 9,
			"intelligence": 7,
			"constitution": 14,
			"perception": 8
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 8,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {
			"loot_pool": [
				{
					"item_id": ItemDefinitions.ITEMS.IRON_LUMP,
					"weight": 10,
					"max_amount": 2
				},
				{
					"item_id": ItemDefinitions.ITEMS.IRON_POLEAXE,
					"weight": 2,
					"max_amount": 1
				},
			],
			"fix_loot_pool": [ItemDefinitions.ITEMS.LEATHER_BELT],
		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

	# ------------------------------------------------------

	GameData.MONSTERS_ALL.MASK: {
		"base_data": {
			"type": MONSTER_TYPES.NORMAL,
			"id": GameData.MONSTERS_ALL.MASK,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.MASK],
			"cost": 6,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FOREST: 0.2,
				GameData.WORLD_TILE_TYPES.FIELD: 0.9,
				},
			"monster_group": 1,
			"text_color": "#4c150d",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Mask",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 58,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 8,
			"damage_max": 14,
			"attack_type": GameData.ATTACK_TYPE.SLASH,
			"accuracy": 0.9,
			"element": GameData.ELEMENT.FIRE,
			"melee_dodge": 0.1,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 26,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.15,
				GameData.ELEMENT.ICE: 0.05,
				GameData.ELEMENT.LIGHTNING: 0.05,
				GameData.ELEMENT.BLOOD: 0.05,
				GameData.ELEMENT.POISON: 0.05,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 11,
			"dexterity": 16,
			"intelligence": 10,
			"constitution": 11,
			"perception": 9
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 10,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

	# ------------------------------------------------------

	GameData.MONSTERS_ALL.FIREANT: {
		"base_data": {
			"type": MONSTER_TYPES.NORMAL, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.FIREANT,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.FIREANT],
			"cost": 5,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.DESERT: 0.8,
				GameData.WORLD_TILE_TYPES.FOREST: 0.4,
				},
			"monster_group": 1,
			"text_color": "#a62121",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Fire Ant",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 40,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 5,
			"damage_max": 12,
			"attack_type": GameData.ATTACK_TYPE.PIERCE,
			"accuracy": 0.9,
			"element": GameData.ELEMENT.FIRE,
			"melee_dodge": 0.1,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 23,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.25,
				GameData.ELEMENT.ICE: -0.1,
				GameData.ELEMENT.LIGHTNING: 0.05,
				GameData.ELEMENT.BLOOD: 0.05,
				GameData.ELEMENT.POISON: 0.05,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 13,
			"dexterity": 14,
			"intelligence": 10,
			"constitution": 8,
			"perception": 11
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 11,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

	# ------------------------------------------------------

	GameData.MONSTERS_ALL.WOLF: {
		"base_data": {
			"type": MONSTER_TYPES.NORMAL,
			"id": GameData.MONSTERS_ALL.WOLF,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.WOLF],
			"cost": 6,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FOREST: 0.8,
				GameData.WORLD_TILE_TYPES.FIELD: 0.4,
				},
			"monster_group": 1,
			"text_color": "#a62121",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Wolf",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 30,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 5,
			"damage_max": 12,
			"attack_type": GameData.ATTACK_TYPE.SLASH,
			"accuracy": 0.9,
			"element": GameData.ELEMENT.PHYSICAL,
			"melee_dodge": 0.1,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 23,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.0,
				GameData.ELEMENT.ICE: 0.2,
				GameData.ELEMENT.LIGHTNING: 0.05,
				GameData.ELEMENT.BLOOD: 0.05,
				GameData.ELEMENT.POISON: 0.05,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 13,
			"dexterity": 14,
			"intelligence": 10,
			"constitution": 8,
			"perception": 11
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 11,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

	# ------------------------------------------------------
	# 					MINIBOSS MONSTERS
	# ------------------------------------------------------

	GameData.MONSTERS_ALL.STONE_CYCLOPS: {
		"base_data": {
			"type": MONSTER_TYPES.MINIBOSS, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.STONE_CYCLOPS,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.STONE_CYCLOPS],
			"cost": 26,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FIELD: 0.1,
				GameData.WORLD_TILE_TYPES.MOUNTAIN: 0.9,
				},
			"monster_group": 1,
			"text_color": "#dfdfdf",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Stone Cyclops",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 250,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 38,
			"damage_max": 49,
			"attack_type": GameData.ATTACK_TYPE.BASH,
			"accuracy": 0.8,
			"element": GameData.ELEMENT.PHYSICAL,
			"melee_dodge": 0.0,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 120,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.25,
				GameData.ELEMENT.ICE: 0.15,
				GameData.ELEMENT.LIGHTNING: 0.20,
				GameData.ELEMENT.BLOOD: 0.4,
				GameData.ELEMENT.POISON: 0.19,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 21,
			"dexterity": 9,
			"intelligence": 7,
			"constitution": 18,
			"perception": 13
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 10,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},


	GameData.MONSTERS_ALL.PUMPKIN: {
		"base_data": {
			"type": MONSTER_TYPES.MINIBOSS, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.PUMPKIN,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.PUMPKIN],
			"cost": 30,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FIELD: 0.1,
				GameData.WORLD_TILE_TYPES.MOUNTAIN: 0.9,
				},
			"monster_group": 1,
			"text_color": "#dfdfdf",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Pumpkin",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 150,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 48,
			"damage_max": 55,
			"attack_type": GameData.ATTACK_TYPE.BASH,
			"accuracy": 0.9,
			"element": GameData.ELEMENT.LIGHTNING,
			"melee_dodge": 0.1,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 6,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.15,
				GameData.ELEMENT.ICE: 0.15,
				GameData.ELEMENT.LIGHTNING: 0.30,
				GameData.ELEMENT.BLOOD: 0.1,
				GameData.ELEMENT.POISON: 0.1,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 18,
			"dexterity": 16,
			"intelligence": 7,
			"constitution": 16,
			"perception": 17
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 10,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

	GameData.MONSTERS_ALL.SANDSTONE_GOLEM: {
		"base_data": {
			"type": MONSTER_TYPES.MINIBOSS, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.SANDSTONE_GOLEM,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.SANDSTONE_GOLEM],
			"cost": 28,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.DESERT: 0.8,
				GameData.WORLD_TILE_TYPES.MOUNTAIN: 0.2,
				},
			"monster_group": 1,
			"text_color": "#dfdfdf",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Sandstone Golem",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 200,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 43,
			"damage_max": 49,
			"attack_type": GameData.ATTACK_TYPE.BASH,
			"accuracy": 0.9,
			"element": GameData.ELEMENT.LIGHTNING,
			"melee_dodge": 0.1,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 6,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.2,
				GameData.ELEMENT.ICE: 0.05,
				GameData.ELEMENT.LIGHTNING: 0.30,
				GameData.ELEMENT.BLOOD: 0.1,
				GameData.ELEMENT.POISON: 0.1,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 22,
			"dexterity": 19,
			"intelligence": 7,
			"constitution": 20,
			"perception": 17
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 12,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},


	# ------------------------------------------------------
	# 					BOSS MONSTERS
	# ------------------------------------------------------

	GameData.MONSTERS_ALL.HOBGOBLIN: {
		"base_data": {
			"type": MONSTER_TYPES.BOSS, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.HOBGOBLIN,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.HOBGOBLIN],
			"cost": 55,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FIELD: 0.2,
				GameData.WORLD_TILE_TYPES.MOUNTAIN: 0.4,
				},
			"monster_group": 1,
			"text_color": "#dfdfdf",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Hobgoblin",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 450,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 50,
			"damage_max": 59,
			"attack_type": GameData.ATTACK_TYPE.BASH,
			"accuracy": 0.9,
			"element": GameData.ELEMENT.PHYSICAL,
			"melee_dodge": 0.05,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 120,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.25,
				GameData.ELEMENT.ICE: 0.25,
				GameData.ELEMENT.LIGHTNING: 0.25,
				GameData.ELEMENT.BLOOD: 0.25,
				GameData.ELEMENT.POISON: 0.35,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 28,
			"dexterity": 16,
			"intelligence": 7,
			"constitution": 20,
			"perception": 18
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 10,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

	GameData.MONSTERS_ALL.TOOTH_FAIRY: {
		"base_data": {
			"type": MONSTER_TYPES.BOSS, # used for determining what child of MonsterBase to make when monster factory preloads monsters
			"id": GameData.MONSTERS_ALL.TOOTH_FAIRY,
			"uid": GameData.MONSTER_UIDS[GameData.MONSTERS_ALL.TOOTH_FAIRY],
			"cost": 61,
			"biome_weights": {
				GameData.WORLD_TILE_TYPES.FIELD: 0.2,
				GameData.WORLD_TILE_TYPES.MOUNTAIN: 0.9,
				},
			"monster_group": 1,
			"text_color": "#dfdfdf",
		},

		GameData.get_component_name(GameData.ComponentKeys.POSITION): {
			
		},

		GameData.get_component_name(GameData.ComponentKeys.IDENTITY): {
			"is_player": false,
			"actor_name": "Tooth Fairy",
			"faction": "monsters",
		},

		GameData.get_component_name(GameData.ComponentKeys.HEALTH): {
			"max_hp": 350,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): {
			"damage_min": 70,
			"damage_max": 89,
			"attack_type": GameData.ATTACK_TYPE.PIERCE,
			"accuracy": 0.95,
			"element": GameData.ELEMENT.POISON,
			"melee_dodge": 0.1,
		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): { # not used yet

		},

		GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): {
			"armor": 120,
			"resistances": {
				GameData.ELEMENT.FIRE: 0.2,
				GameData.ELEMENT.ICE: 0.2,
				GameData.ELEMENT.LIGHTNING: 0.20,
				GameData.ELEMENT.BLOOD: 0.15,
				GameData.ELEMENT.POISON: 0.4,
			}
		},

		GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): {
			"strength": 21,
			"dexterity": 28,
			"intelligence": 16,
			"constitution": 19,
			"perception": 20
		},

		GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): {
			"type": "chase",
			"is_hostile": true,
			"vision_range": 13,
		},

		GameData.get_component_name(GameData.ComponentKeys.STAMINA): {

		},

		GameData.get_component_name(GameData.ComponentKeys.STATE): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): {

		},

		GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): {
			
		}
	},

}
