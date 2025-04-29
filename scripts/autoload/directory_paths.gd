extends Node
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

const weapon_scenes = {
    "steel_longsword": "res://scenes/items/weapons/swords/steel_longsword.tscn",
}

# --- SCRIPT CLASSES ---

#     -- save/load --
const save_player = "res://scripts/autoload/save_load/save_classes/save_player.gd"
const load_player = "res://scripts/autoload/save_load/load_classes/load_player.gd"

const load_data = "res://scripts/autoload/save_load/load_classes/load_data.gd"

#     -- entity systems --
const movement_system = "res://scripts/ECS/systems/movement_system.gd"
const combat_system = "res://scripts/ECS/systems/combat_system.gd"
const entity_spawner = "res://scripts/ECS/systems/entity_spawner.gd"



# --- MAPS ---
const starting_village = "res://maps/premade_maps/starting_village.tscn"
const first_outpost = "res://maps/premade_maps/first_outpost.tscn"

