extends Node


signal player_acted


signal actor_hit(target, attacker, damage, direction, element, hit_action)
# hit action: 0 -> hit, 1 -> miss, 2 -> target blocked, from enum GameData.HIT_ACTIONS
# signal actor_hit(hit_data: Dictionary)


# emited when player blocks and block power changes
signal block_power_changed(new_value, max_value)