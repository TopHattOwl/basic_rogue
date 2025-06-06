extends Node


signal player_acted


# called when actor tries hitting another, used for calculations
signal actor_hit(hit_data: Dictionary)

# called when calculations are done and damage is applied -> for animation and stuff
signal actor_hit_final(hit_data: Dictionary)

# emited when player blocks and block power changes
signal block_power_changed(new_value, max_value)


# emited when equipment was successfully changed
signal equipment_changed(data: Dictionary)

# emited when trying to change equipment
signal equipment_changing(item: ItemResource, slot: int)

signal new_game_stared



# --- GAME TIME ---
signal day_passed()
signal month_passed()
signal year_passed()


# --- INVENTORY ---
signal inventory_closed()