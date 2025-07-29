extends Node
## when player enters a world map tile amush manager creates ambushes depending on savagery, monster tiers, and other factors maybe
## replaces fixed spawn points in WorldMonsterTile

# var monster_weights: Dictionary = {}


## holds monsters that can be bought
## holds base_data for each monster, see MonsterDefinitions
var monsters: Dictionary = {}

var savagery: int

var debug: int

var money: int

func _ready() -> void:
	SignalBus.world_node_ready.connect(_on_world_node_ready)
	debug = GameData.ambush_debug


## sets the data for the ambush
func _on_world_node_ready() -> void:
	var player_world_pos = GameData.player.PlayerComp.world_map_pos

	# monster_weights = MonsterDefinitions.get_avalible_monsters(WorldMapData.biome_map.get_biome_type(player_world_pos))
	monsters = MonsterDefinitions.get_avalible_monsters(WorldMapData.biome_map.get_biome_type(player_world_pos))
	savagery = WorldMapData.world_map_savagery[player_world_pos.y][player_world_pos.x]
	
	var ambush_chance: float = clampf((float(savagery) / 10) * 0.4 * TimeDifficulty.ambush_chance_multiplier, 0, 0.75)

	if debug:
		print("--- AMBUSH MANAGER ---")
		print("ambush manager")
		print("monster ids: ", monsters.keys())
		print("monsters data: ", monsters)
		print("chance for ambush: ", ambush_chance)


	if randf() > ambush_chance:
		if debug:	
			print("no ambush")
			print("--- AMBUSH MANAGER END ---")
		return
	
	if debug:
		print("ambush")

	# getting spawin points

	var random_grid = Vector2i(
		randi_range(GameData.MAP_SIZE.x / 4, GameData.MAP_SIZE.x - GameData.MAP_SIZE.x / 4),
		randi_range(GameData.MAP_SIZE.y / 4, GameData.MAP_SIZE.y - GameData.MAP_SIZE.y / 4)
	)

	var avaliable_spawns = MapFunction.get_tiles_in_radius(random_grid, 7, false, false, "chebyshev", true, true)


	# num of monsters depending on game tile and savagery, clamped between 1 and another number
	# for now debug number
	var num_of_monsters = int(randi_range(1, 5 + savagery / 2) * TimeDifficulty.ambush_money_multiplier)
	
	
	var current_monsters = 0
	var loops = 0

	var monster_names = [] # for debug


	# TODO: change to money based system
	# while current_monsters < num_of_monsters:
	# 	if loops > 100:
	# 		return
		
	# 	var grid = avaliable_spawns[randi_range(0, avaliable_spawns.size() - 1)]
	# 	avaliable_spawns.erase(grid)

	# 	var monster_id = WeightedRandomizer.weighted_random_monster(monsters.biome_weights)
	# 	EntitySpawner.spawn_monster(grid, monster_id)
	# 	current_monsters += 1
	# 	loops += 1
	# 	monster_names.append(GameData.MONSTER_UIDS[monster_id])

	print("monsters spawned: ", num_of_monsters)
	print("monsters: ", monster_names)
	print("--- AMBUSH MANAGER END ---")
