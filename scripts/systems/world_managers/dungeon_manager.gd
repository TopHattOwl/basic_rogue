extends Node
## autoload, after world map set dungeon positions, this manages dungeons
## when dungeon is clear set timer, few weeks and repopulate dungeon with random abalible monster type as boss
## afther dungeon repopulate make a contract in nerby settlement

const DUNGEON_THROTTLE_LIMIT := 5 # number of dungeon to generate per frame

var debug := GameData.dungeon_debug
var rng: RandomNumberGenerator = null


func set_seed() -> void:
	rng = RandomNumberGenerator.new()
	rng.seed = GameData.world_seed




## Generates all dungeons [br]
## no terrain data is generated, only basic data [br]
## terrain data is generated when player enters the dungeon level, each time
func generate_dungeons() -> void:
	if not rng:
		set_seed()
		if debug:
			print("dungeon generation called before setting seed!!!")
	
	var world_size = GameData.WORLD_MAP_SIZE.x * GameData.WORLD_MAP_SIZE.y
	var num_of_dungeons: int = int(world_size * 0.7 * 0.05 * rng.randf_range(0.9, 1.1))
	#	           ~30% of the world is water ^^^^^  ^^^^^ ~ 5% of it will be dungeons

	var cave_num = 0
	var castle_num = 0
	var temple_num = 0
	var camp_num = 0
	var tower_num = 0

	var positions: Array[Vector2i] = []

	if debug:
		print("--- GENERATING DUNGEONS ---")

	SignalBus.loading_label_changed.emit("Generating dungeons...")

	for id in num_of_dungeons:

		# find good position
		var _i = 0
		var pos_found := false
		var dungeon_pos: Vector2i
		while _i < 200 and !pos_found:
			var random_pos = Vector2i(rng.randi_range(0, GameData.WORLD_MAP_SIZE.x - 1), rng.randi_range(0, GameData.WORLD_MAP_SIZE.y - 1))
			# check if tile is walkable
			if not WorldMapData.world_map2.is_tile_walkable(random_pos):
				_i += 1
				continue
			
			# check if dungeon is already there
			if positions.has(random_pos):
				_i += 1
				continue
			pos_found = true
			dungeon_pos = random_pos
			positions.append(dungeon_pos)
			_i += 1

		# skip if can't find position
		if not pos_found:
			continue
		
		var dungeon_data: Dictionary = DungeonDefinitions.get_dungeon_data(dungeon_pos)
		dungeon_data["id"] = id

		match dungeon_data.get("dungeon_type", 0):
			GameData.DUNGEON_TYPES.CASTLE:
				castle_num += 1
				DungeonFactory.make_dungeon(dungeon_data, CastleDungeon)
			GameData.DUNGEON_TYPES.CAVE:
				cave_num += 1
				DungeonFactory.make_dungeon(dungeon_data, CaveDungeon)
			GameData.DUNGEON_TYPES.TEMPLE:
				temple_num += 1
				DungeonFactory.make_dungeon(dungeon_data, TempleDungeon)
			GameData.DUNGEON_TYPES.CAMP:
				camp_num += 1
				DungeonFactory.make_dungeon(dungeon_data, CampDungeon)
			GameData.DUNGEON_TYPES.TOWER:
				tower_num += 1
				DungeonFactory.make_dungeon(dungeon_data, TowerDungeon)

		if id % DUNGEON_THROTTLE_LIMIT == 0:
			await get_tree().process_frame
		
		SignalBus.loading_screen_progressed.emit(float(id) / float(num_of_dungeons - 1))



	if debug:
		print("--- DUNGEONS GENERATED ---")
		print("total number of dungeons: ", num_of_dungeons)
		var ratio = 100 * (float(num_of_dungeons) / float(world_size))
		print("dungeon to world size ratio: %.2f" % ratio, "%")

		print("\t- cave num: ", cave_num)
		print("\t- castle num: ", castle_num)
		print("\t- temple num: ", temple_num)
		print("\t- camp num: ", camp_num)
		print("\t- tower num: ", tower_num)
