extends Monster

var max_hp = 35

var monster_combat_component = {
	"damage_min": 8,
	"damage_max": 14,
	"attack_type": GameData.ATTACK_TYPE.BASH,
	"accuracy": 0.9,
	"element": GameData.ELEMENT.PHYSICAL,
	"element_weight": 0.0,
	"melee_dodge": 0.1
}

var defense_stats_component = {
	"armor": 35,
	"resistances": {
		GameData.ELEMENT.FIRE: 0.05,
		GameData.ELEMENT.ICE: 0.05,
		GameData.ELEMENT.LIGHTNING: 0.05,
		GameData.ELEMENT.BLOOD: 0.5,
		GameData.ELEMENT.POISON: 0.05,
	}
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
	"constitution": 12,
	"perception": 12
}

var identity_component = {
	"is_player": false,
	"actor_name": "Mask",
	"faction": "monsters"
}

var monster_properties_componenet = {
	
}

var monster_stats_component = {
	"armor": 0,
	"monster_tier": 1,
	"monster_id": GameData.MONSTERS_ALL.MASK,
}

var monster_drops_component = {
	"loot_pool": []
}

@export var text_color: String = "#4c150d"

func _ready() -> void:

	calculate_stats()

	get_component(GameData.ComponentKeys.HEALTH).initialize(max_hp)
	get_component(GameData.ComponentKeys.MONSTER_COMBAT).initialize(monster_combat_component)
	get_component(GameData.ComponentKeys.DEFENSE_STATS).initialize(defense_stats_component)
	get_component(GameData.ComponentKeys.AI_BEHAVIOR).initialize(ai_behavior_component)
	get_component(GameData.ComponentKeys.ATTRIBUTES).initialize(attributes_component)
	get_component(GameData.ComponentKeys.IDENTITY).initialize(identity_component)
	get_component(GameData.ComponentKeys.MONSTER_PROPERTIES).initialize(monster_properties_componenet)
	get_component(GameData.ComponentKeys.MONSTER_STATS).initialize(monster_stats_component)
	get_component(GameData.ComponentKeys.MONSTER_DROPS).initialize(monster_drops_component)

	connect_signals()

	
func calculate_stats() -> void:

	# Time difficulty calcualtion
	var monster_stats = {
		"monster_combat_component": monster_combat_component,
		"health_component": max_hp
	}
	TimeDifficulty.calc_monster_stats(monster_stats, self)