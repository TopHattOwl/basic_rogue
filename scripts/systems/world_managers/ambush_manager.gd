extends Node

## when player enters a world map tile amush manager creates ambushes depending on savagery, monster tiers, and other factors maybe
## replaces fixed spawn points in WorldMonsterTile

var monster_ids: Array = []

func _ready() -> void:
	SignalBus.world_node_ready.connect(_on_world_node_ready)


## sets the data for the ambush
func _on_world_node_ready() -> void:
	var player_world_pos = GameData.player.PlayerComp.world_map_pos
	monster_ids = WorldMapData.world_monster_map.get_monster_ids(GameData.player.PlayerComp.world_map_pos)

	var savagery = WorldMapData.world_map_savagery[player_world_pos.y][player_world_pos.x]
	var tier = WorldMapData.world_monster_map.map_data[player_world_pos.y][player_world_pos.x].monster_tier
	var ambush_chance: float = float(savagery) / (7.0 - float(tier)) /10

	print("ambush manager, monster ids: ", monster_ids)
	print("chance for ambush: ", ambush_chance)
