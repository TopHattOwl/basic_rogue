extends Node2D

var max_hp = 30

var monster_combat_component = {
	"damage_min": 10,
	"damage_max": 19,
	"attack_type": GameData.ATTACK_TYPE.SLASH,
	"accuracy": 0.8,
	"element": GameData.ELEMENT.PHYSICAL,
	"element_weight": 0.0,
	"melee_dodge": 0.05
}

var defense_stats_component = {
	"armor": 35,
	"resistances": {
		GameData.ELEMENT.FIRE: 0.05,
		GameData.ELEMENT.ICE: 0.05,
		GameData.ELEMENT.LIGHTNING: 0.5,
		GameData.ELEMENT.BLOOD: 0.05,
		GameData.ELEMENT.POISON: 0.05,
	}
}

var ai_behavior_component = {
	"type": "chase",
	"is_hostile": true,
	"vision_range": 8,
}

var attributes_component = {
	"strength": 13,
	"dexterity": 9,
	"intelligence": 7,
	"constitution": 14,
	"perception": 8
}

var identity_component = {
	"is_player": false,
	"actor_name": "Iron Worm",
	"faction": "monsters"
}

var monster_properties_componenet = {
	
}

var monster_stats_component = {
	"armor": 2,
	"monster_tier": 1,
	"monster_id": GameData.MONSTERS_ALL.IRON_WORM,
}

var monster_drops_component = {
	"loot_pool": []
}

@export var text_color: String = "#dfdfdf"

func _ready() -> void:

	ComponentRegistry.get_component(self, GameData.ComponentKeys.HEALTH).initialize(max_hp)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_COMBAT).initialize(monster_combat_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.DEFENSE_STATS).initialize(defense_stats_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.AI_BEHAVIOR).initialize(ai_behavior_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.ATTRIBUTES).initialize(attributes_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.IDENTITY).initialize(identity_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_PROPERTIES).initialize(monster_properties_componenet)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_STATS).initialize(monster_stats_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_DROPS).initialize(monster_drops_component)
