extends Node

## emitted when player completed an action that costs energy
signal player_action_completed(action: Action)

## EnergyTurnManager migration: replace with player_action_completed
signal make_turn_pass()

## EnergyTurnManager migration: replace with turn_passed
signal player_acted()


## emitted when a whole turn passed (no actors with energy left)
signal turn_passed()


## emitted when actor tries hitting another, used for calculations
signal actor_hit(hit_data: Dictionary)
# var hit_data_template = {
#     "target": Node2D,
#     "attacker": Node2D,
#     "damage": int damage that will be calculated,
#     "direction": Vector2i, direction for animation
#     "element": int from enum ELEMENT,
#     "hit_action": int from enum HIT_ACTIONS,
#     "combat_type": int from enum COMBAT_TYPE
# }

## emitted when calculations are done and damage is applied -> for animation and stuff
signal actor_hit_final(hit_data: Dictionary)


## emitted when actor is removed from scene but did not die
signal actor_removed(actor: Node2D)

## emitted when actor dies after it will be removed from scene
signal actor_died(actor: Node2D)
signal actor_spawned(actor: Node2D)



# --- SPELLS ---

## emited when spell has been cast, not when trying to cast
## NOT USED, projectile spawned used instead when spell node is _ready
signal spell_casted(spell_data: Dictionary)
# var spell_data_setup = {
#     "caster": Node2D,
#     "spell": SpellResource,
#     "target_grid": Vector2i # not always needed
# }

# --- ---
# --- PROJECTILES ---

signal projectile_spawned(projectile_data: Dictionary)
signal projectile_finished(projectile_data: Dictionary)

# projectile_data will hold projectile node instance
# dictionary key will be projectile type name
# "spell": SpellNode
# "arrow": ArrowNode
# etc.

# --- ---

# --- FOV ---

# emitted when world map is loaded in and terrain map is filled or
# when dungeon map is loaded
# used in fov manager to initialize fov
signal calculate_fov()

# emitted when fov finished calculating
# used for monster visibility
signal fov_calculated()


# --- WORLD MAP ---

# emitted when player's world_map_pos is set
signal world_map_pos_changed(to: Vector2i, from: Vector2i)

# emitted when world node is loaded in
signal world_node_ready()
# used for ambush manager to create ambushes

# when dungeon node is ready spawn entites that dungeon manager placed on dungeon levels
signal dungeon_node_ready()


signal entered_premade_map(data: Dictionary)


# --- DUNGEONS ---

signal entered_dungeon(data: Dictionary)
signal exited_dungeon(data: Dictionary)
signal dungeon_level_changed(new_level: int, old_level: int)


signal buff_added(buff: Buff, actor: Node2D)
signal buff_removed(buff: Buff, actor: Node2D)


# emited when player blocks and block power changes
signal block_power_changed(new_value, max_value)


# emited when equipment was successfully changed
signal equipment_changed(data: Dictionary)

# emited when player trying to change equipment
signal equipment_changing(item: ItemResource, slot: int)

signal new_game_stared()


signal game_state_changed(new_state: int)



# --- GAME TIME ---
signal day_passed()
signal month_passed()
signal year_passed()


# --- INVENTORY ---
signal inventory_opened()
signal inventory_closed()

# emied when inventory ui window need to update
signal inventory_update()

signal item_window_opened()
signal item_window_closed()



# --- INPUT ---

## emited when player inputs directional input, [br]
## NOT used for movement. [br]
## Used for aiming, looking, etc.
signal directional_input(direction: Vector2i)
signal waiting_for_directional_input()



# --- SKILL ---

signal skill_leveled_up(skill_tree_id: int)



# --- TALK SCREEN ---



# --- CONTRACT ---

signal contract_generated(data: Dictionary)
signal contract_taken(data: Dictionary)
signal contract_completed(data: Dictionary)
signal contract_turned_in(data: Dictionary)
signal contract_failed(data: Dictionary)


# --- LOADING SCREEN ---

signal loading_screen_progressed(progress: float)
signal loading_label_changed(text: String)


# --- 

# when item is dropped on the ground
signal item_dropped(item: ItemResource, grid_pos: Vector2i)

# when single item is picked up
signal item_picked_up(item: ItemResource, grid_pos: Vector2i, entity: Node2D)

# when all items are picked up from a position
signal all_items_picked_up(grid_pos: Vector2i)