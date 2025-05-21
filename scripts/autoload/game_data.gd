extends Node

var world_seed: int = 2840132 # set when starting new game

# ___ Main Node ___

var main_node: Node2D

func set_main_node(value: Node2D) -> void:
	if not value is Node2D:
		push_error("Main node must be a Node2D")
		return
	
	if not value.is_inside_tree():
		push_error("Main node must be in the scene tree")
		return

	main_node = value
	print("Main node set", main_node.name)


# ___ Constants ___
const TILE_SIZE = Vector2i(16, 24) # tile size in pixels
const MAP_SIZE = Vector2i(82, 37) # map size in tiles
const WORLD_MAP_SIZE = Vector2i(110, 75)
const OFFSET = Vector2i(8, 12)

# ___ Player ___
var player_scene = DirectoryPaths.player_scene
var player: Node2D

# ___ Etities ___
var all_hostile_actors: Array = []
var all_friendly_actors: Array = []

var all_actors: Array = []

var all_items: Array = []

func remove_entities_from_tree() -> void:
	if all_hostile_actors.size() > 0:
		for actor in all_hostile_actors:
			actor.queue_free()
	if all_items.size() > 0:
		for item in all_items:
			item.queue_free()

func reset_entity_variables() -> void:
	all_hostile_actors = []
	all_friendly_actors = []
	all_actors = []
	all_items = []

func get_actor(grid_pos: Vector2i) -> Node2D:
	if not MapFunction.is_in_bounds(grid_pos):
		return null
	return actors_map[grid_pos.y][grid_pos.x]

# ___ MONSTERS ___

# tier 1 monsters
enum MONSTERS1 {
	# field
	IRON_WORM,
	MASK

	# swamp
}

enum MONSTERS2 {
	PLACEHOLDER,
}

enum MONSTERS_ALL {
	# tier 1
	IRON_WORM,
	MASK,

	# tier 2
	PLACEHOLDER
}

# monster tiers (1-5) -> monster biome (what biome it can appear in) -> monster key array
var MonstersAll = {
	1: {
		WORLD_TILE_TYPES.FIELD: [MONSTERS_ALL.IRON_WORM, MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.SWAMP: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.DESERT: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.MOUNTAIN: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.FOREST: [MONSTERS_ALL.MASK],

	},
	2: {
		WORLD_TILE_TYPES.FIELD: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.SWAMP: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.DESERT: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.MOUNTAIN: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.FOREST: [MONSTERS_ALL.MASK],
		
	},
	3: {
		WORLD_TILE_TYPES.FIELD: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.SWAMP: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.DESERT: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.MOUNTAIN: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.FOREST: [MONSTERS_ALL.MASK],
		
	},
	4: {
		WORLD_TILE_TYPES.FIELD: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.SWAMP: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.DESERT: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.MOUNTAIN: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.FOREST: [MONSTERS_ALL.MASK],
		
	},
	5: {
		WORLD_TILE_TYPES.FIELD: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.SWAMP: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.DESERT: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.MOUNTAIN: [MONSTERS_ALL.MASK],
		WORLD_TILE_TYPES.FOREST: [MONSTERS_ALL.MASK],
		
	}
}


# ___ Maps ___

var current_map: Node2D = null
var current_dungeon = {}

var terrain_map: Array = []
var actors_map: Array = []
var items_map: Array = []

func reset_maps() -> void:
	terrain_map = []
	actors_map = []
	items_map = []

# ___ Tiles ___


var TileDatas = {
	TILE_TAGS.NONE: {
		"walkable": true,
		"transparent": true,
	},
	TILE_TAGS.FLOOR: {
		"walkable": true,
		"transparent": true,
	},
	TILE_TAGS.WALL: {
		"walkable": false,
		"transparent": false,
	},
	TILE_TAGS.STAIR: {
		"walkable": false,
		"transparent": true,
	},
	TILE_TAGS.DOOR: {
		"walkable": true,
		"transparent": true,
	},
	TILE_TAGS.DOOR_FRAME: {
		"walkable": true,
		"transparent": true,
	},
	TILE_TAGS.NATURE: {
		"walkable": false,
		"transparent": true,
	}
}

var TilemapLayers = {
	TILE_TAGS.NONE: "NoneLayer",
	TILE_TAGS.FLOOR: "FloorLayer",
	TILE_TAGS.WALL: "WallLayer",
	TILE_TAGS.STAIR: "StairLayer",	
	TILE_TAGS.DOOR: "DoorLayer",
	TILE_TAGS.DOOR_FRAME: "DoorFrameLayer",
	TILE_TAGS.NATURE: "NatureLayer"
}


var WorldMapTileLayer = {
	WORLD_TILE_TYPES.CITY: "City",
	WORLD_TILE_TYPES.VILLAGE: "Village",
	WORLD_TILE_TYPES.OUTPOST: "Outpost",
	WORLD_TILE_TYPES.ROAD: "Road",

	WORLD_TILE_TYPES.SWAMP: "Swamp",
	WORLD_TILE_TYPES.FOREST: "Forest",
	WORLD_TILE_TYPES.FIELD: "Field",
	WORLD_TILE_TYPES.DESERT: "Desert",
	WORLD_TILE_TYPES.MOUNTAIN: "Mountain",

	WORLD_TILE_TYPES.WATER: "Water",
	WORLD_TILE_TYPES.RIVER: "Rriver",
}

func get_tile_data(tile_tag: int) -> Dictionary:
	return TileDatas.get(tile_tag, {})

# ___ Input ___

const INPUT_DIRECTIONS ={
	"numpad_1": Vector2i(-1, 1),
	"numpad_2": Vector2i(0, 1),
	"numpad_3": Vector2i(1, 1),
	"numpad_4": Vector2i(-1, 0),
	"numpad_5": Vector2i(0, 0),
	"numpad_6": Vector2i(1, 0),
	"numpad_7": Vector2i(-1, -1),
	"numpad_8": Vector2i(0, -1),
	"numpad_9": Vector2i(1, -1),
}

enum INPUT_MODES {
	ZOOMED_IN_MOVEMENT,
	WORLD_MAP_MOVEMENT,
	LOOK,
	WORLD_MAP_LOOK,
	UI_INPUT
}

# ___ Component Data ___



const COMPONENTS = {
	# ACTORS
	ComponentKeys.ABILITIES: "Components/AbilitiesComponent",
	ComponentKeys.AI_BEHAVIOR: "Components/AiBehaviorComponent",
	ComponentKeys.ATTRIBUTES: "Components/AttributesComponent",
	ComponentKeys.EQUIPMENT: "Components/EquipmentComponent",
	ComponentKeys.HEALTH: "Components/HealthComponent",
	ComponentKeys.IDENTITY: "Components/IdentityComponent",
	ComponentKeys.INVENTORY: "Components/InventoryComponent",
	ComponentKeys.MELEE_COMBAT: "Components/MeleeCombatComponent",
	ComponentKeys.POSITION: "Components/PositionComponent",
	ComponentKeys.MONSTER_PROPERTIES: "Components/MonsterPropertiesComponent",
	ComponentKeys.MONSTER_STATS: "Components/MonsterStatsComponent",
	ComponentKeys.MONSTER_DROPS: "Components/MonsterDropsComponent",
	ComponentKeys.SPELLS: "Components/SpellsComponent",
	ComponentKeys.STAMINA: "Components/StaminaComponent",
	ComponentKeys.STATE: "Components/StateComponent",
	ComponentKeys.PLAYER: "Components/PlayerComponent",
	ComponentKeys.SKILLS: "Components/SkillsComponent",

	# ITEMS
	ComponentKeys.ITEM_POSITION: "Components/ItemPositionComponent",
	ComponentKeys.ITEM_IDENTITY: "Components/ItemIdentityComponent",
	ComponentKeys.ITEM_SKILL: "Components/ItemSkillComponent",

	ComponentKeys.WEAPON_STATS: "Components/WeaponStatsComponent",
}

func get_component_path(component_key: int) -> String:
	return COMPONENTS.get(component_key, "")

func get_component_name(component_key: int) -> String:
	var component_name = COMPONENTS.get(component_key, "").replace("Components/", "")
	return component_name

# ___ Enums ___

# ATTRIBUTES
enum ATTRIBUTES {
	STRENGTH,
	DEXTERITY,
	INTELLIGENCE,
	CONSTITUTION,
	# PERCEPTION,
}

# ATTACK TYPE
enum ATTACK_TYPE {
	SLASH,
	BASH,
	PIERCE,
}

enum ELEMENT {
	PHYSICAL,
	FIRE,
	ICE,
	ELECTRICITY,
}


# COMPONENTS
enum ComponentKeys {
	# ACTORS
	ABILITIES,
	AI_BEHAVIOR,
	ATTRIBUTES,
	EQUIPMENT,
	HEALTH,
	IDENTITY,
	INVENTORY,
	MELEE_COMBAT,
	POSITION,
	MONSTER_PROPERTIES,
	MONSTER_STATS,
	MONSTER_DROPS,
	SPELLS,
	STAMINA,
	STATE,
	PLAYER,
	SKILLS,

	# ITEMS
	ITEM_POSITION,
	ITEM_IDENTITY,
	ITEM_SKILL,

	WEAPON_STATS,
}

enum ENTITY_TAGS {
	NONE,
	PLAYER,
	MONSTER,
	NPC,
	ITEM,
}

# MAP
enum TILE_TAGS {
	NONE,
	FLOOR,
	STAIR,
	DOOR,
	DOOR_FRAME,
	NATURE,
	WALL,
}

# world map
enum WORLD_TILE_TYPES {
	# civilization
	CITY,
	VILLAGE,
	OUTPOST,
	ROAD,

	# nature
	SWAMP,
	FOREST,
	FIELD,
	DESERT,
	MOUNTAIN,

	# water
	WATER,
	RIVER,

}

# SKILLS
enum SKILLS {
	SWORD,
	AXE,
	SPEAR,
	POLEAXE,
	BOW,
}

# ITEMS
enum ARMOR_SLOTS {
	HEAD,
	SHOULDERS,
	CHEST,
	ARMS,
	HANDS,
	LEGS,
	FEET
}

enum ITEM_TYPES {
	WEAPON,
	RANGED_WEAPON,
	ARMOR,
	POTION,
	POWDER,
	MONSTER_PART,
	RESOURCE,
	OTHER
}

enum WEAPON_TYPES {
	SWORD,
	AXE,
	SPEAR,
}

enum WEAPON_SUBTYPES {
	SWORD_1H,
	SWORD_2H,
	AXE_1H,
	AXE_2H,
	SPEAR_1H,
	SPEAR_2H
}

enum RANGED_WEAPONS {

}

# 	all items

enum ALL_ITEMS {
	# weapons
	STEEL_LONGSWORD,

	# armor
	LEATHER_CHEST,
	LEATHER_LEGS,
	LEATHER_BOOTS,

	# potions
}
