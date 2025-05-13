extends Node

# --- MAIN NODE ---

const main_node_scene = "res://main_node.tscn"

# --- PLAYER ---
const player_data_json = "res://resources/actors/player.json"
const player_scene = "res://scenes/actors/player/player.tscn"


# --- ACTORS ---

const monsters1 = {
    GameData.MONSTERS1.GIANT_WORM: "res://resources/actors/monsters/giant_worm.json",
    GameData.MONSTERS1.MASK: "",
}

const monsters1_scenes = {
    GameData.MONSTERS1.GIANT_WORM: "res://scenes/actors/monsters/giant_worm.tscn",
    GameData.MONSTERS1.MASK: "",
}


const monster1_remains_scene = {
    GameData.MONSTERS1.GIANT_WORM: "res://scenes/actors/monsters/remains/bloody_remains.tscn",
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


# const load_data = "res://scripts/autoload/save_load/load_classes/load_data.gd"

#     -- entity systems --
const movement_system = "res://scripts/ECS/systems/movement_system.gd"
const combat_system = "res://scripts/ECS/systems/combat_system.gd"
const entity_spawner = "res://scripts/ECS/systems/entity_spawner.gd"
const inventory_system = "res://scripts/ECS/systems/inventory_system.gd"



# --- MAPS ---
const first_outpost = "res://maps/premade_maps/first_outpost.tscn"
const field_with_hideout = "res://maps/premade_maps/field_with_hideout.tscn"


# --- WORLD MAP ---

const world_map_scene = "res://maps/world_map/world_map.tscn"

# --- MAP GENERATORS ---

const map_generator = "res://scripts/map_generation/map_generator.gd"
const dungeon_generator = "res://scripts/map_generation/dungeon_generator.gd"


# --- UI ---
const main_menu_scene = "res://scenes/ui/main_menu/main_menu.tscn"
const pick_up_window_scene = "res://scenes/ui/items/pick_up_window.tscn"
const pick_up_window_script = "res://scenes/ui/items/pick_up_window.gd"