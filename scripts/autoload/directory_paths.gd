extends Node

# --- MAIN NODE ---

const main_node_scene = "res://main_node.tscn"

# --- PLAYER ---
const player_data_json = "res://resources/actors//player/player.json"
const player_scene = "res://scenes/actors/player/player.tscn"



# --- COMPONENT PATHS ---

var component_paths = {
	# ACTORS
	GameData.get_component_name(GameData.ComponentKeys.ABILITIES): "res://scripts/ECS/components/actors/component_scripts/abilities_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.AI_BEHAVIOR): "res://scripts/ECS/components/actors/component_scripts/ai_behavior_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.ATTRIBUTES): "res://scripts/ECS/components/actors/component_scripts/attributes_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.EQUIPMENT): "res://scripts/ECS/components/actors/component_scripts/equipment_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.HEALTH): "res://scripts/ECS/components/actors/component_scripts/health_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.IDENTITY): "res://scripts/ECS/components/actors/component_scripts/identity_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.INVENTORY): "res://scripts/ECS/components/actors/component_scripts/iventory_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.MELEE_COMBAT): "res://scripts/ECS/components/actors/component_scripts/melee_combat_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.BLOCK): "res://scripts/ECS/components/actors/component_scripts/block_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.DEFENSE_STATS): "res://scripts/ECS/components/actors/component_scripts/defense_stats_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.POSITION): "res://scripts/ECS/components/actors/component_scripts/position_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.SPELLS): "res://scripts/ECS/components/actors/component_scripts/spells_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.STAMINA): "res://scripts/ECS/components/actors/component_scripts/stamina_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.STATE): "res://scripts/ECS/components/actors/component_scripts/state_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.PLAYER): "res://scripts/ECS/components/actors/component_scripts/player_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.HOTBAR): "res://scripts/ECS/components/actors/component_scripts/hotbar_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.SKILLS): "res://scripts/ECS/components/actors/component_scripts/skills_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.STANCE): "res://scripts/ECS/components/actors/component_scripts/stance_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.MODIFIERS): "res://scripts/ECS/components/actors/component_scripts/modifiers_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.MONSTER_PROPERTIES): "res://scripts/ECS/components/actors/component_scripts/monster_properties_component.gd",

	# MONSTERS
	GameData.get_component_name(GameData.ComponentKeys.MONSTER_STATS): "res://scripts/ECS/components/actors/component_scripts/monster_stats_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.MONSTER_DROPS): "res://scripts/ECS/components/actors/component_scripts/monster_drops_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.MONSTER_COMBAT): "res://scripts/ECS/components/actors/component_scripts/monster_combat_component.gd",

	# NPCS
	GameData.get_component_name(GameData.ComponentKeys.SHOP_KEEPER): "res://resources/actors/npcs/components/shop_keeper_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.QUEST_GIVER): "res://resources/actors/npcs/components/quest_giver_component.gd",
	GameData.get_component_name(GameData.ComponentKeys.TALK): "res://resources/actors/npcs/components/talk_component.gd",
}



# --- SPELLS ---

# path to spell resources using spell udi
const spell_resources = {
	# single target spells
	"test_spell": "res://resources/spells/spell_instances/test_spell.tres",


	# turret spells
	"test_turret_spell": "res://resources/spells/spell_instances/test_turret_spell.tres",
}

const spell_scenes = {
	# single target spells
	"test_spell": "res://scenes/spells/test_spell/test_spell.tscn",

	# turret spells
	"test_turret_spell": "res://scenes/spells/test_turret_spell/test_turret_spell.tscn"
}


# --- TARGETERS ---

const base_targeter_art = "res://assets/targeter.png"
const base_targeter_path_art = "res://assets/targeter_path_line.png"


const available_tile_scene = "res://scenes/available_tiles/available_tiles.tscn"


# 	   -- range sprite stuff --

const in_range_art = "res://assets/targeter_stuff/in_range_tiles.png"
const will_hit_tile_art = "res://assets/targeter_stuff/hit_tiles.png"
# --- SCRIPT CLASSES ---

#     -- save/load --
const save_player = "res://scripts/autoload/save_load/save_classes/save_player.gd"
const load_player = "res://scripts/autoload/save_load/load_classes/load_player.gd"

const save_world_map = "res://scripts/autoload/save_load/save_classes/save_world_map.gd"
const load_world_map = "res://scripts/autoload/save_load/load_classes/load_world_map.gd"
const world_map_data_save = "res://resources/world_map_data/world_save.sav"
const biome_type_world_map_data_save = "res://resources/world_map_data/world_save_biome_type.sav"
const monster_world_map_data_save = "res://resources/world_map_data/world_save_monsters.sav"
const world_map_savagery_save = "res://resources/world_map_data/world_save_savagery.sav"
const world_map_civilization_save = "res://resources/world_map_data/world_save_civilization.sav"

const biome_map_save = "res://resources/world_map_data/biome/biome_map.tres"
const world_map_save = "res://resources/world_map_data/world_map/world_map.tres"
const world_monster_map_save = "res://resources/world_map_data/world_monster_map/world_monster_map.tres"



# --- MAPS ---

# current map will be a copy of this if tile is not premade
# terrain data gets loaded into this Node when generating
const world = "res://maps/world.tscn"

const dungeon = "res://maps/dungeon.tscn"


# --- WORLD MAP ---

const world_map_scene = "res://maps/world_map/world_map.tscn"

# --- MAP GENERATORS ---

const map_generator = "res://scripts/map_generation/map_generator.gd"
const dungeon_generator = "res://scripts/map_generation/dungeon_generator.gd"


# --- UI ---
const main_menu_scene = "res://scenes/ui/main_menu/main_menu.tscn"

const damage_text_scene = "res://scenes/ui/damage_text.tscn"

const inventory_item = "res://scenes/ui/player_ui/inventory/inventory_item.tscn"

const item_window_scene = "res://scenes/ui/items/item_window.tscn"

const buff_icon_scene = "res://scenes/ui/hud/buffs/buff_icon.tscn"
const buff_hover_tooltip_scene = "res://scenes/ui/hud/buffs/buff_hover_tooltip.tscn"

const talk_screen_scene = "res://scenes/ui/talk/talk_screen.tscn"



# --- SPRITES/TILEMAPS ---

var monster_sprites = {
	GameData.MONSTERS_ALL.IRON_WORM: "res://assets/monsters/giant_worm.png",
	GameData.MONSTERS_ALL.MASK: "res://assets/monsters/mask.png",
	GameData.MONSTERS_ALL.FIREANT: "res://assets/monsters/insectoids/fireant.png",
	GameData.MONSTERS_ALL.STONE_CYCLOPS: "res://assets/monsters/stone/stone_cyclops.png",

	GameData.MONSTERS_ALL.HOBGOBLIN: "",
	GameData.MONSTERS_ALL.TOOTH_FAIRY: "",
	GameData.MONSTERS_ALL.WOLF: "",
	GameData.MONSTERS_ALL.PUMPKIN: "",
	GameData.MONSTERS_ALL.SANDSTONE_GOLEM: "",
}

var monster_remains_sprites = {
	GameData.MONSTERS_ALL.IRON_WORM: "res://assets/monsters/remains/bloody_remains.png",
	GameData.MONSTERS_ALL.MASK: "res://assets/monsters/remains/mask_remains.png",
	GameData.MONSTERS_ALL.FIREANT: "",
	GameData.MONSTERS_ALL.STONE_CYCLOPS: "",

	GameData.MONSTERS_ALL.HOBGOBLIN: "",
	GameData.MONSTERS_ALL.TOOTH_FAIRY: "",
	GameData.MONSTERS_ALL.WOLF: "",
	GameData.MONSTERS_ALL.PUMPKIN: "",
	GameData.MONSTERS_ALL.SANDSTONE_GOLEM: "",
}

var npc_sprites = {
	GameData.NPCS_ALL.WIZARD: "res://assets/npcs/wizard.png",
	GameData.NPCS_ALL.BLACKSMITH: "res://assets/npcs/blacksmith.png",
}


# --- NPC JSON ---

var npc_conversations_json = {
	GameData.NPCS_ALL.WIZARD: "res://resources/actors/npcs/talk_trees/wizard/wizard.json",
	GameData.NPCS_ALL.BLACKSMITH: "res://resources/actors/npcs/talk_trees/blacksmith/blacksmith.json",
}

# --- TILE SETS ---

# biome type -> tile layer -> tileset resource
var BiomeTileSets = {
	GameData.WORLD_TILE_TYPES.SWAMP: {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "",
		GameData.TILE_TAGS.DOOR: "",
		GameData.TILE_TAGS.DOOR_FRAME: "",
		GameData.TILE_TAGS.NATURE: "",
		GameData.TILE_TAGS.WALL: "",
	},
	GameData.WORLD_TILE_TYPES.FIELD: {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "res://resources/tiles/biome_sets/field/field_stair_tileset.tres",
		GameData.TILE_TAGS.DOOR: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.DOOR_FRAME: "res://resources/tiles/biome_sets/field/field_door_tileset.tres",
		GameData.TILE_TAGS.NATURE: "res://resources/tiles/biome_sets/field/field_nature_tileset.tres",
		GameData.TILE_TAGS.WALL: "res://resources/tiles/biome_sets/field/field_wall_tileset.tres",
	},
	GameData.WORLD_TILE_TYPES.FOREST: {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "",
		GameData.TILE_TAGS.DOOR: "",
		GameData.TILE_TAGS.DOOR_FRAME: "",
		GameData.TILE_TAGS.NATURE: "",
		GameData.TILE_TAGS.WALL: "",
	},
	GameData.WORLD_TILE_TYPES.DESERT: {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "",
		GameData.TILE_TAGS.DOOR: "",
		GameData.TILE_TAGS.DOOR_FRAME: "",
		GameData.TILE_TAGS.NATURE: "",
		GameData.TILE_TAGS.WALL: "",
	},
	GameData.WORLD_TILE_TYPES.MOUNTAIN: {
		GameData.TILE_TAGS.FLOOR: "res://resources/tiles/biome_sets/field/field_floor_tileset.tres",
		GameData.TILE_TAGS.STAIR: "",
		GameData.TILE_TAGS.DOOR: "",
		GameData.TILE_TAGS.DOOR_FRAME: "",
		GameData.TILE_TAGS.NATURE: "",
		GameData.TILE_TAGS.WALL: "",
	},
}
