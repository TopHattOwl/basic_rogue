class_name IdentityComponent
extends Node

var is_player: bool = false
var actor_name: String = ""
var faction: String = ""


func initialize(d: Dictionary) -> void:
    is_player = d.get("is_player", false)
    actor_name = d.get("actor_name", "")
    faction = d.get("faction", "")
