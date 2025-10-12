extends Node
## autoload, after world map set dungeon positions, this manages dungeons
## when dungeon is clear set timer, few weeks and repopulate dungeon with random abalible monster type as boss
## afther dungeon repopulate make a contract in nerby settlement

var debug := GameData.dungeon_debug


# generates all dungeons
func generate_dungeons() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = GameData.world_seed

	var world_size = GameData.WORLD_MAP_SIZE.x * GameData.WORLD_MAP_SIZE.y
	var num_of_dungeons: int = int(world_size * 0.7 * 0.05 * rng.randf_range(0.9, 1.1))
	#	           ~30% of the world is water ^^^^^  ^^^^^ ~ 5% of it will be dungeons

	if debug:
		print("total number of dungeons: ", num_of_dungeons)
		var ratio = 100 * (float(num_of_dungeons) / float(world_size))
		print("dungeon to world size ratio: %.2f" % ratio, "%")


	var positions: Array[Vector2i] = []
	for id in num_of_dungeons:

		# find good position
		var _i = 0
		var pos_found := false
		var dungeon_pos: Vector2i
		while _i < 200 and !pos_found:
			var random_pos = Vector2i(rng.randi_range(0, GameData.WORLD_MAP_SIZE.x - 1), rng.randi_range(0, GameData.WORLD_MAP_SIZE.y - 1))

			# check if tile is walkable
			if not WorldMapData.world_map2.is_tile_walkable(random_pos) or not WorldMapData.world_map2.is_in_bounds(random_pos):
				continue
			
			# check if dungeon is already there
			if positions.has(random_pos):
				continue

			pos_found = true
			dungeon_pos = random_pos
			positions.append(dungeon_pos)
			_i += 1

		if not pos_found:
			if debug:
				print("can't find position for dungeon with id: ", id)
			continue
		
		var dungeon_data: Dictionary = DungeonDefinitions.get_dungeon_data(dungeon_pos)
		dungeon_data["id"] = id
		var dungeon = DungeonFactory.make_dungeon(dungeon_data)
