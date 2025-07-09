extends Node

# --- MAIN NODE ---

const main_node_scene = "res://main_node.tscn"

# --- PLAYER ---
const player_data_json = "res://resources/actors/player.json"
const player_scene = "res://scenes/actors/player/player.tscn"


# --- ACTORS ---

const monster_remains_scene = {
	# bloody remains
	GameData.MONSTERS_ALL.IRON_WORM: "res://scenes/actors/monsters/remains/bloody_remains.tscn",
	# GameData.MONSTERS_ALL.BIG_B: "res://scenes/actors/monsters/remains/bloody_remains.tscn",


	# ash
	GameData.MONSTERS_ALL.MASK: "res://scenes/actors/monsters/remains/mask_remains.tscn",
}

const monster_scenes = {
	# tier 1
	GameData.MONSTERS_ALL.IRON_WORM: "res://scenes/actors/monsters/tier_1/iron_worm.tscn",
	GameData.MONSTERS_ALL.MASK: "res://scenes/actors/monsters/tier_1/mask.tscn",

	# # tier 2
	# GameData.MONSTERS_ALL.PLACEHOLDER: "",


	# # special
	# GameData.MONSTERS_ALL.BIG_B: "res://scenes/actors/monsters/special/big_b.tscn",
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
const first_outpost = "res://maps/premade_maps/first_outpost.tscn"
const field_with_hideout = "res://maps/premade_maps/field_with_hideout.tscn"

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
# const pick_up_window_scene = "res://scenes/ui/items/pick_up_window.tscn"
# const pick_up_window_script = "res://scenes/ui/items/pick_up_window.gd"

const damage_text_scene = "res://scenes/ui/damage_text.tscn"

const inventory_item = "res://scenes/ui/player_ui/inventory/inventory_item.tscn"

const item_window_scene = "res://scenes/ui/items/item_window.tscn"

const buff_icon_scene = "res://scenes/ui/hud/buffs/buff_icon.tscn"
const buff_hover_tooltip_scene = "res://scenes/ui/hud/buffs/buff_hover_tooltip.tscn"



# --- SPRITES/TILEMAPS ---

var monster_sprites = {
	GameData.MONSTERS_ALL.IRON_WORM: "res://assets/monsters/giant_worm.png",
	GameData.MONSTERS_ALL.MASK: "res://assets/monsters/mask.png",
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
