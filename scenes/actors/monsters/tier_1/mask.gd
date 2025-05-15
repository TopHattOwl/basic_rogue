extends Node2D

var max_hp = 15

var melee_combat_component = {
	"damage": [1, 4, []],
	"attack_type": GameData.ATTACK_TYPE.BASH,
	"element": GameData.ELEMENT.PHYSICAL,
	"to_hit_bonus": 0
}

var ai_behavior_component = {
	"type": "chase",
	"is_hostile": true,
	"vision_range": 12,
}

var attributes_component = {
	"strength": 10,
	"dexterity": 15,
	"intelligence": 11,
	"constitution": 12
}

var identity_component = {
	"is_player": false,
	"actor_name": "Mask",
	"faction": "monsters"
}

var abilities_component = {
	"abilities": []
}

var spells_component = {
	"spells": []
}

var monster_properties_componenet = {
	
}

var monster_stats_component = {
	"armor": 0,
	"monster_tier": 1,
	"monster_id": GameData.MONSTERS1.MASK,
}

var monster_drops_component = {
	"loot_pool": []
}

func _ready() -> void:

	ComponentRegistry.get_component(self, GameData.ComponentKeys.HEALTH).initialize(max_hp)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MELEE_COMBAT).initialize(melee_combat_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.AI_BEHAVIOR).initialize(ai_behavior_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.ATTRIBUTES).initialize(attributes_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.IDENTITY).initialize(identity_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.ABILITIES).initialize(abilities_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.SPELLS).initialize(spells_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_PROPERTIES).initialize(monster_properties_componenet)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_STATS).initialize(monster_stats_component)
	ComponentRegistry.get_component(self, GameData.ComponentKeys.MONSTER_DROPS).initialize(monster_drops_component)
	pass
