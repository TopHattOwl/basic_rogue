extends Node

# --- MAIN NODE ---

const main_node_scene = "res://main_node.tscn"

# --- PLAYER ---
const player_data_json = "res://resources/actors/player.json"
const player_scene = "res://scenes/actors/player/player.tscn"


# --- ACTORS ---

# const monsters1 = {
#     GameData.MONSTERS1.IRON_WORM: "res://resources/actors/monsters/giant_worm.json",
#     GameData.MONSTERS1.MASK: "",
# }

const monsters1_scenes = {
    GameData.MONSTERS1.IRON_WORM: "res://scenes/actors/monsters/tier_1/iron_worm.tscn",
    GameData.MONSTERS1.MASK: "res://scenes/actors/monsters/tier_1/mask.tscn",
}

const monster1_remains_scene = {
    GameData.MONSTERS1.IRON_WORM: "res://scenes/actors/monsters/remains/bloody_remains.tscn",
    GameData.MONSTERS1.MASK: "res://scenes/actors/monsters/remains/mask_remains.tscn",
}

const monster_scenes = {
    # tier 1
    GameData.MONSTERS_ALL.IRON_WORM: "res://scenes/actors/monsters/tier_1/iron_worm.tscn",
    GameData.MONSTERS_ALL.MASK: "res://scenes/actors/monsters/tier_1/mask.tscn",

    # tier 2
    GameData.MONSTERS_ALL.PLACEHOLDER: "",
}

# --- ITEMS ---

const item_scenes = {
    # weapons
    GameData.ALL_ITEMS.STEEL_LONGSWORD: "res://scenes/items/weapons/swords/steel_longsword.tscn",
}

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


# const load_data = "res://scripts/autoload/save_load/load_classes/load_data.gd"

#     -- entity systems --
const movement_system = "res://scripts/ECS/systems/movement_system.gd"
const combat_system = "res://scripts/ECS/systems/combat_system.gd"
const entity_spawner = "res://scripts/ECS/systems/entity_spawner.gd"
const inventory_system = "res://scripts/ECS/systems/inventory_system.gd"



# --- MAPS ---
const first_outpost = "res://maps/premade_maps/first_outpost.tscn"
const field_with_hideout = "res://maps/premade_maps/field_with_hideout.tscn"

# current map will be a copy of this if tile is not premade
# terrain data gets loaded into this Node when generating
const world = "res://maps/world.tscn"


# --- WORLD MAP ---

const world_map_scene = "res://maps/world_map/world_map.tscn"

# --- MAP GENERATORS ---

const map_generator = "res://scripts/map_generation/map_generator.gd"
const dungeon_generator = "res://scripts/map_generation/dungeon_generator.gd"


# --- UI ---
const main_menu_scene = "res://scenes/ui/main_menu/main_menu.tscn"
const pick_up_window_scene = "res://scenes/ui/items/pick_up_window.tscn"
const pick_up_window_script = "res://scenes/ui/items/pick_up_window.gd"




# --- SPRITES/TILEMAPS ---

const wall_tile_set = "res://resources/tiles/wall/wall.tres"


const targeter = "res://scenes/ui/targeter/targeter.tscn"


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