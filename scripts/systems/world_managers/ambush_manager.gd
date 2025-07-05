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
	var ambush_chance: float = clampf(float(savagery) / (7.0 - float(tier)) /5, 0, 0.75)
	print("ambush manager, monster ids: ", monster_ids)
	print("chance for ambush: ", ambush_chance)


	if randf() > ambush_chance:
		print("no ambush")
		return
	
	print("ambush")

	# getting spawin points

	var random_grid = Vector2i(
		randi_range(GameData.MAP_SIZE.x / 4, GameData.MAP_SIZE.x - GameData.MAP_SIZE.x / 4),
		randi_range(GameData.MAP_SIZE.y / 4, GameData.MAP_SIZE.y - GameData.MAP_SIZE.y / 4)
	)

	var avaliable_spawns = MapFunction.get_tiles_in_radius(random_grid, 7, false, false, "chebyshev", true, true)
	# num of monsters depending on game tile and savagery, clamped between 1 and another number
	# for now debug number
	var num_of_monsters = int(randi_range(1, 5 + savagery / 2) * TimeDifficulty.spawn_number_multiplyer)
	
	
	var current_monsters = 0
	var loops = 0
	while current_monsters < num_of_monsters:
		if loops > 100:
			return
		
		var grid = avaliable_spawns[randi_range(0, avaliable_spawns.size() - 1)]
		avaliable_spawns.erase(grid)

		EntitySpawner.spawn_monster(grid, monster_ids[randi_range(0, monster_ids.size() - 1)])
		current_monsters += 1
		loops += 1

	print("monsters spawned: ", num_of_monsters)

