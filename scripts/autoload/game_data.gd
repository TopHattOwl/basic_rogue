extends Node

const dev_mode := true

var world_seed: int = 2840132 # set when starting new game
var main_rng: RandomNumberGenerator = RandomNumberGenerator.new()

# func _ready() -> void:
# 	main_rng.seed = world_seed
# 	print("main rng seed set: ", main_rng.seed)

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

func set_world_seed(_seed: int) -> void:
	world_seed = _seed
	print("main world seed set: ", world_seed)
	main_rng.seed = world_seed

	# set other random number generators
	DungeonManager.set_seed()

# ___ Constants ___
const TILE_SIZE = Vector2i(16, 24) # tile size in pixels
const WORLD_SPAWN_POS = Vector2i(43, 33) # the tile player spawns on when entering world tile
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

## removes all entities, resets and initializes maps.
## called when transitioning map, entering world map tile, entering dungeon
## also initializes fov data
func remove_entities(is_player_in_dungeon: bool = false) -> void:
	# remove entities from tree
	if all_hostile_actors.size() > 0:
		for actor in all_hostile_actors:
			actor.queue_free()
	if all_items.size() > 0:
		for item in all_items:
			item.queue_free()
	if all_friendly_actors.size() > 0:
		for actor in all_friendly_actors:
			actor.queue_free()
	var remains = main_node.get_tree().get_nodes_in_group("remains")
	if remains.size() > 0:
		for remain in remains:
			remain.queue_free()
	
	# reset entity holders
	all_hostile_actors = []
	all_friendly_actors = []
	all_actors = []
	all_items = []

	# reset map data dependig on player is in dungeon or not
	if !is_player_in_dungeon:

		MapFunction.initialize_map_data()
	else:

		MapFunction.initialize_dungeon_map_data()


## returns actor at given grid position
func get_actor(grid_pos: Vector2i) -> Node2D:
	if !actors_map:
		return null
	if not MapFunction.is_in_bounds(grid_pos):
		return null
	
	if !actors_map[grid_pos.y][grid_pos.x]:
		return null
	
	return actors_map[grid_pos.y][grid_pos.x]

	

# ___ MONSTERS ___

enum MONSTERS_ALL {
	IRON_WORM,
	MASK,
	FIREANT,
	STONE_CYCLOPS,


	# not fully finished
	# 	bosses
	HOBGOBLIN,
	TOOTH_FAIRY,

	# minboss
	PUMPKIN,
	SANDSTONE_GOLEM,

	# 	normal
	WOLF,

	


	# # tier 2
	# PLACEHOLDER,


	# # special
	# BIG_B,
}

var MONSTER_UIDS = {
	MONSTERS_ALL.IRON_WORM: "worm",
	MONSTERS_ALL.MASK: "mask",
	MONSTERS_ALL.FIREANT: "fire_ant",
	MONSTERS_ALL.STONE_CYCLOPS: "stone_cyclops",

	# not fully finished
	MONSTERS_ALL.HOBGOBLIN: "hobgoblin",
	MONSTERS_ALL.TOOTH_FAIRY: "tooth_fairy",
	MONSTERS_ALL.WOLF: "wolf",
	MONSTERS_ALL.PUMPKIN: "pumpkin",
	MONSTERS_ALL.SANDSTONE_GOLEM: "sandstone_golem",

}

# monster tiers (1-5) -> monster biome (what biome it can appear in) -> monster key array
var HostileBiomes = [
		WORLD_TILE_TYPES.FIELD,
		WORLD_TILE_TYPES.SWAMP,
		WORLD_TILE_TYPES.DESERT,
		WORLD_TILE_TYPES.MOUNTAIN,
		WORLD_TILE_TYPES.FOREST,
]

# ___ NPCs ___

enum NPCS_ALL {
	
	WIZARD,
	BLACKSMITH,

}

var NPC_UIDS = {
	NPCS_ALL.WIZARD: "wizard",
	NPCS_ALL.BLACKSMITH: "blacksmith",
}

# ___ Maps ___

# references to map scenes
var current_map: Node2D = null
var current_dungeon: Node2D = null

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
		"transparent": false,
	},
	TILE_TAGS.DOOR_FRAME: {
		"walkable": true,
		"transparent": true,
	},
	TILE_TAGS.NATURE: {
		"walkable": false,
		"transparent": false,
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

# the names of the tilesmap layer nodes on world map
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

const INPUT_DIRECTIONS = {
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

const HOTBAR_INPUTS = [
	"hotbar_1",
	"hotbar_2",
	"hotbar_3",
	"hotbar_4",
	"hotbar_5",
	"hotbar_6",
	"hotbar_7",
	"hotbar_8",
	"hotbar_9",
	"hotbar_0",
]

enum INPUT_MODES {
	ZOOMED_IN_MOVEMENT,
	WORLD_MAP_MOVEMENT,
	LOOK,
	WORLD_MAP_LOOK,
	DUNGEON_INPUT,


	# aiming
	SPELL_AIMING,
	DIRECTION, # used when asking player to pick one of the 8 directions


	# UI stuff
	STANCE_SELECTION,
	INVENTORY,
	TALK_SCREEN,

	# DEBUG
	CONSOLE,
	
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
	ComponentKeys.BLOCK: "Components/BlockComponent",
	ComponentKeys.DEFENSE_STATS: "Components/DefenseStatsComponent",
	ComponentKeys.POSITION: "Components/PositionComponent",
	ComponentKeys.SPELLS: "Components/SpellsComponent",
	ComponentKeys.STAMINA: "Components/StaminaComponent",
	ComponentKeys.STATE: "Components/StateComponent",
	ComponentKeys.PLAYER: "Components/PlayerComponent",
	ComponentKeys.HOTBAR: "Components/HotbarComponent",
	ComponentKeys.SKILLS: "Components/SkillsComponent",
	ComponentKeys.STANCE: "Components/StanceComponent",
	ComponentKeys.MODIFIERS: "Components/ModifiersComponent",

	# MONSTERS
	ComponentKeys.MONSTER_PROPERTIES: "Components/MonsterPropertiesComponent",
	ComponentKeys.MONSTER_STATS: "Components/MonsterStatsComponent",
	ComponentKeys.MONSTER_DROPS: "Components/MonsterDropsComponent",
	ComponentKeys.MONSTER_COMBAT: "Components/MonsterCombatComponent",
	ComponentKeys.MONSTER_MODIFIERS: "Components/MonsterModifiersComponent",

	# NPCS

	ComponentKeys.SHOP_KEEPER: "Components/ShopKeeperComponent",
	ComponentKeys.QUEST_GIVER: "Components/QuestGiverComponent",
	ComponentKeys.TALK: "Components/TalkComponent",

}

# COMPONENTS
enum ComponentKeys {
	# PLAYER
	ABILITIES,
	EQUIPMENT,
	INVENTORY,
	MELEE_COMBAT,
	BLOCK,
	PLAYER,
	SKILLS,
	STANCE,
	HOTBAR,
	MODIFIERS,

	# ALL ACTORS
	AI_BEHAVIOR,

	ATTRIBUTES,
	HEALTH,
	IDENTITY,
	DEFENSE_STATS,
	POSITION,

	# maybe players and monsters, right not just player
	SPELLS,
	STAMINA,
	STATE,

	# MONSTERS
	MONSTER_PROPERTIES,
	MONSTER_STATS,
	MONSTER_COMBAT,
	MONSTER_MODIFIERS,
	MONSTER_DROPS,


	# NPC
	SHOP_KEEPER,
	QUEST_GIVER,
	TALK,

}

func get_component_path(component_key: int) -> String:
	return COMPONENTS.get(component_key, "")

## Returns the name of the component (e.g. "MeleeCombatComponent")
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
	PERCEPTION,
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
	LIGHTNING,
	BLOOD,
	POISON,
}

# SPELLS

enum SPELL_TYPE {OFFENSIVE, DEFENSIVE}
enum SPELL_SUBTYPE {
	# OFFENSIVE
	SINGLE_TARGET,
	AOE,
	ARMAMENT_BOOST,
	TURRET,

	# DEFENSIVE

	ARMOR_INFUSE,
}

const SPELL_TYPE_NAMES = {
	SPELL_TYPE.OFFENSIVE: "offensive",
	SPELL_TYPE.DEFENSIVE: "defensive",
}

const SPELL_SUBTYPE_NAMES = {
	SPELL_SUBTYPE.SINGLE_TARGET: "single target",
	SPELL_SUBTYPE.AOE: "area of effect",
	SPELL_SUBTYPE.ARMAMENT_BOOST: "armament boost",
	SPELL_SUBTYPE.TURRET: "turret",
	SPELL_SUBTYPE.ARMOR_INFUSE: "armor infuse",
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
	NONE = -1,
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

enum DUNGEON_TYPES {
	CASTLE,
	CAVE,
	TEMPLE,
	CAMP,
	TOWER,
}

# SKILLS
enum SKILLS {
	# WEAPONS
	SWORD,
	AXE,
	SPEAR,
	MACE,
	POLEAXE,
	BOW,

	# COMBAT SKILLS
	MELEE,
	BLOCK,

	# ELEMENTS
	FIRE,
	ICE,
	LIGHTNING,
	BLOOD,
	POISON,
}

var SKILL_NAMES = {
	SKILLS.SWORD: "Sword",
	SKILLS.AXE: "Axe",
	SKILLS.SPEAR: "Spear",
	SKILLS.MACE: "Mace",
	SKILLS.POLEAXE: "Poleaxe",
	SKILLS.BOW: "Bow",

	SKILLS.MELEE: "Melee",
	SKILLS.BLOCK: "Block",

	SKILLS.FIRE: "Fire",
	SKILLS.ICE: "Ice",
	SKILLS.LIGHTNING: "Lightning",
	SKILLS.BLOOD: "Blood",
	SKILLS.POISON: "Poison",
}


# ITEMS

enum ITEM_TYPES {
	WEAPON,
	RANGED_WEAPON,
	SHIELD,
	ARMOR,
	POTION,
	POWDER,
	MONSTER_PART,
	ALCHEMY,
	RESOURCE,
	OTHER
}

const ITEM_TAB_NAMES = {
	ITEM_TYPES.WEAPON: "Weapons",
	ITEM_TYPES.RANGED_WEAPON: "Ranged Weapons",
	ITEM_TYPES.SHIELD: "Shields",
	ITEM_TYPES.ARMOR: "Armor",
	ITEM_TYPES.POTION: "Potions",
	ITEM_TYPES.POWDER: "Powders",
	ITEM_TYPES.MONSTER_PART: "Monster Parts",
	ITEM_TYPES.ALCHEMY: "Alchemy",
	ITEM_TYPES.RESOURCE: "Resources",
	ITEM_TYPES.OTHER: "Other",
}

const ITEM_TAB_SIZES = {
	ITEM_TYPES.WEAPON: 20,
	ITEM_TYPES.RANGED_WEAPON: 15,
	ITEM_TYPES.SHIELD: 15,
	ITEM_TYPES.ARMOR: 35,
	ITEM_TYPES.POTION: 0,
	ITEM_TYPES.POWDER: 0,
	ITEM_TYPES.MONSTER_PART: 0,
	ITEM_TYPES.ALCHEMY: 0,
	ITEM_TYPES.RESOURCE: 0,
	ITEM_TYPES.OTHER: 0
}

enum EQUIPMENT_SLOTS {
	MAIN_HAND,
	OFF_HAND,
	HEAD,
	SHOULDERS,
	CHEST,
	ARMS,
	HANDS,
	LEGS,
	FEET,
	BELT,
}

enum ARMOR_SLOTS {
	HEAD,
	SHOULDERS,
	CHEST,
	ARMS,
	HANDS,
	LEGS,
	FEET
}

enum ARMOR_TYPES {
	LIGHT,
	MEDIUM,
	HEAVY,
}



enum WEAPON_TYPES {
	SWORD,
	AXE,
	SPEAR,
	MACE,
	POLEAXE,
	BOW,
}

enum WEAPON_SUBTYPES {
	SWORD_1H,
	SWORD_2H,
	AXE_1H,
	AXE_2H,
	SPEAR_1H,
	SPEAR_2H,
	MACE_1H,
	MACE_2H,
}

enum RANGED_WEAPONS {

}


# MODIFIERS OPERATION

enum MODIFIER_OPERATION {
	ADD,
	MULTIPLY,
	OVERRIDE,
}


enum HIT_ACTIONS {
	HIT, # attacker hit
	MISS, # attacker missed bc target dodged
	BLOCKED, # target blocked the attack
}

## default is melee
enum COMBAT_TYPE {
	MELEE,
	RANGED,
	SPELL,
}



# SETTLEMENTS

enum ALL_SETTLEMENTS {
	START_OUTPOST,
	TEST_CITY,
	STARTING_VILLAGE,
	TEST_OUTPOST
}



# --- Z INDEXES ---

const TALK_SCREEN_Z_INDEX = 25


# debug options
var combat_system_debug := 0
var melee_combat_debug := 0
var spell_debug := 0
var turn_manager_debug := 0
var input_manager_debug := 0
var hot_bar_debug := 0
var map_functions_debug := 0
var biome_debug := 1 # for biome generation and loading in Biome classes
var fov_manager_debug := 0
var item_debug := 0
var inventory_debug := 0
var modifiers_debug := 0
var skill_debug := 0
var leveling_system_debug := 0
var ambush_debug := 0
var contract_debug := 0
var settlement_manager_debug := 0
var new_game_window_debug := 0
var dungeon_debug := 1

var dungeon_draw_debug := 1 # for drawing all dungeons at start