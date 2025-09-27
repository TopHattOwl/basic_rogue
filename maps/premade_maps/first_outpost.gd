extends Node2D



func _ready():
	EntitySpawner.spawn_npc(Vector2i(17, 2), GameData.NPCS_ALL.WIZARD)
