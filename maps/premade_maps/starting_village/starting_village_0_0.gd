extends Node2D


func _ready() -> void:
	EntitySpawner.spawn_npc(Vector2i(20, 29), GameData.NPCS_ALL.BLACKSMITH)
    