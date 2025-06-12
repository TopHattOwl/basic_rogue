extends Node


signal player_acted()
signal make_turn_pass()


# called when actor tries hitting another, used for calculations
signal actor_hit(hit_data: Dictionary)

# called when calculations are done and damage is applied -> for animation and stuff
signal actor_hit_final(hit_data: Dictionary)



# spells

## emited when spell has been cast, not when trying to cast
signal spell_casted(spell_dat: Dictionary)

# var spell_data_setup = {
#     "caster": Node2D,
#     "spell": SpellResource,
#     "target_grid": Vector2i # not always needed
# }



signal buff_added(buff: Buff, actor: Node2D)
signal buff_removed(buff: Buff, actor: Node2D)


# emited when player blocks and block power changes
signal block_power_changed(new_value, max_value)


# emited when equipment was successfully changed
signal equipment_changed(data: Dictionary)

# emited when player trying to change equipment
signal equipment_changing(item: ItemResource, slot: int)

signal new_game_stared



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