extends Node


signal player_acted


# called when actor tries hitting another, used for calculations
signal actor_hit(hit_data: Dictionary)

# called when calculations are done and damage is applied -> for animation and stuff
signal actor_hit_final(hit_data: Dictionary)

# emited when player blocks and block power changes
signal block_power_changed(new_value, max_value)


signal equipment_changed(data: Dictionary)


signal new_game_stared