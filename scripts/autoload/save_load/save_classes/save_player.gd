class_name SavePlayer

extends Node


func save_player_data(player: Node2D) -> bool:
    var save_data := {}
    
    # Health Component
    var health_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.HEALTH)
    if health_comp:
        save_data["health_component"] = {
            "max_hp": health_comp.max_hp,
            "hp": health_comp.hp
        }
    
    # Position Component
    var position_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.POSITION)
    if position_comp:
        save_data["position_component"] = {
            "grid_pos": {
                "x": position_comp.grid_pos.x,
                "y": position_comp.grid_pos.y
            }
        }
    
    # Attributes Component
    var attributes_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.ATTRIBUTES)
    if attributes_comp:
        save_data["attributes_component"] = {
            "strength": attributes_comp.strength,
            "dexterity": attributes_comp.dexterity,
            "intelligence": attributes_comp.intelligence,
            "constitution": attributes_comp.constitution
        }
    
    # # Equipment Component
    # var equipment_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.EQUIPMENT)
    # if equipment_comp:
    #     var equipment_data := {
    #         "weapon": _get_weapon_data(equipment_comp.weapon),
    #         "shield": _get_shield_data(equipment_comp.shield),
    #         "ranged_weapon": _get_ranged_weapon_data(equipment_comp.ranged_weapon),
    #         "armor": _get_armor_data(equipment_comp.armor)
    #     }
    #     save_data["equipment_component"] = equipment_data
    
    # Identity Component
    var identity_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.IDENTITY)
    if identity_comp:
        save_data["identity_component"] = {
            "is_player": identity_comp.is_player,
            "actor_name": identity_comp.actor_name,
            "faction": identity_comp.faction
        }
    
    # # Melee Combat Component
    # var melee_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.MELEE_COMBAT)
    # if melee_comp:
    #     save_data["melee_combat_component"] = {
    #         "damage": melee_comp.damage,
    #         "attack_type": melee_comp.attack_type,
    #         "element": melee_comp.element,
    #         "to_hit_bonus": melee_comp.to_hit_bonus
    #     }
    
    # Player Comonent
    var player_comp = ComponentRegistry.get_component(player, GameData.ComponentKeys.PLAYER)
    if player_comp:
        save_data["player_component"] = {
            "is_in_dungeon": player_comp.is_in_dungeon,
            "is_players_turn": player_comp.is_players_turn
        }

    # Save to file
    return _write_save_file(DirectoryPaths.player_data_json, save_data)

# Helper functions for equipment serialization
func _get_weapon_data(weapon) -> Dictionary:
    if not weapon or weapon.is_empty():
        return {}
    
    return {
        "base_type": weapon.base_type,
        "name": weapon.name,
        "base_stats": weapon.base_stats,
        "modifications": weapon.modifications,
        "full_stats": weapon.full_stats
    }

func _get_shield_data(shield) -> Dictionary:
    return shield if shield else {}

func _get_ranged_weapon_data(ranged_weapon) -> Dictionary:
    return ranged_weapon if ranged_weapon else {}

func _get_armor_data(armor_slots: Dictionary) -> Dictionary:
    var armor_data := {}
    for slot in GameData.ArmorSlots.values():
        armor_data[slot] = armor_slots.get(slot, null)
    return armor_data

# File handling with error checking
func _write_save_file(path: String, data: Dictionary) -> bool:
    var file := FileAccess.open(path, FileAccess.WRITE)
    if FileAccess.get_open_error() != OK:
        push_error("Failed to open save file: %s" % path)
        return false
    
    var json_string := JSON.stringify(data, "\t")
    file.store_string(json_string)
    file.close()
    return true