extends Node

enum MONSTER_TYPES { NORMAL, MINIBOSS, BOSS }

var monster_definitions = {
    # NORMAL MONSTERS
    # ------------------------------------------------------
    GameData.MONSTERS_ALL.IRON_WORM: {
        "base_data": {
            "type": MONSTER_TYPES.NORMAL, # used for determining what child of MonsterBase to make when monster factory preloads monsters
            "id": GameData.MONSTERS_ALL.IRON_WORM,
            "uid": "iron_worm",
            "cost": 8,
            "biome_weights": {
                GameData.WORLD_TILE_TYPES.FOREST: 0.8,
                GameData.WORLD_TILE_TYPES.FIELD: 0.4,
                },
            "monster_group": 1,
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

        },
    },

    # ------------------------------------------------------

    GameData.MONSTERS_ALL.MASK: {
        "base_data": {
            "type": MONSTER_TYPES.NORMAL,
            "id": GameData.MONSTERS_ALL.MASK,
            "uid": "mask",
            "cost": 5,
            "biome_weights": {
                GameData.WORLD_TILE_TYPES.FOREST: 0.2,
                GameData.WORLD_TILE_TYPES.FIELD: 0.9,
                },
            "monster_group": 1,
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
    },



    # MINIBOSS MONSTERS


    # BOSS MONSTERS
}



