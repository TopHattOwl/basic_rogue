extends Node
## when player enters a world map tile amush manager creates ambushes depending on savagery, monster tiers, and other factors maybe
## replaces fixed spawn points in WorldMonsterTile

# var monster_weights: Dictionary = {}


## holds monsters that can be bought
## holds base_data for each monster, see MonsterDefinitions
## will be sorted when AmbushManager calculates monsters
var monsters: Dictionary = {}

var savagery: int

var debug: int

var money: int

var player_world_pos: Vector2i

var ambush: Array


var remaining_money: int
var sorted_monsters: Array
var boss_bought: bool

func _ready() -> void:
	SignalBus.world_node_ready.connect(_on_world_node_ready)
	debug = GameData.ambush_debug


## sets the data for the ambush
func _on_world_node_ready() -> void:
	reset_variables()
	var monster_names = [] # for debug

	player_world_pos = GameData.player.PlayerComp.world_map_pos

	monsters = MonsterDefinitions.get_avalible_monsters(WorldMapData.biome_map.get_biome_type(player_world_pos))
	savagery = WorldMapData.world_map_savagery[player_world_pos.y][player_world_pos.x]
	
	var ambush_chance: float = clampf((float(savagery) / 10) * 0.4 * TimeDifficulty.ambush_chance_multiplier, 0, 0.75)

	if debug:
		print("--- AMBUSH MANAGER ---")
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

	var available_spawns = MapFunction.get_tiles_in_radius(random_grid, 7, false, false, "chebyshev", true, true)
	calc_money()
	remaining_money = money
	sorted_monsters = sort_monster()
	boss_bought = false

	if debug:
		print("sorted monster: \n", sorted_monsters)

	try_buy_boss()
	# while remaining_money > 0:
	# 	pass



	# DEBUG END PRINT
	if debug:
		print("Ambush manager money: ", money)
		print("Spent money: ", money - remaining_money)
		print("monsters: ", monster_names)
		if boss_bought:
			print("\tboss spawned")
			print("\tboss: ", ambush[0])
		else:
			print("boss not spawned")
		print("--- AMBUSH MANAGER END ---")


func calc_money() -> void:
	var _money = floori(float(savagery) * 3.5 * TimeDifficulty.ambush_money_multiplier)

	# randomness
	_money = randi_range(_money * 0.8, _money * 1.2)

	money = _money

func sort_monster() -> Array:
	var sorted_monsters = []

	for monster_id in monsters.keys():
		sorted_monsters.append({
			"id": monster_id,
			"data": monsters[monster_id]
		})
	
	sorted_monsters.sort_custom(func(a, b): return a.data.cost > b.data.cost)

	return sorted_monsters

func can_buy_trash(to_be_bought_cost: int, num_of_trash: int) -> bool:
	if debug:
		print("--- CAN BUY TRASH ---")
		print("to be bought cost: ", to_be_bought_cost)
		print("remaining money: ", remaining_money)
		print("sorted_monsters: ", sorted_monsters)
		print("num of trash: ", num_of_trash)
	
	var money_after_buy = remaining_money - to_be_bought_cost

	var lowest_cost = sorted_monsters[-1].data.cost

	if lowest_cost * num_of_trash > money_after_buy:
		if debug:
			print("lowest cost * num of trash is higher than money after buy")
			print("--- CAN BUY TRASH END ---")
		return false 

	if debug:
		print("boss can be bought")
		print("--- CAN BUY TRASH END ---")
	return true

func try_buy_boss() -> bool:
	var bosses = sorted_monsters.filter(func(monster): return monster.data.type == MonsterDefinitions.MONSTER_TYPES.BOSS)
	var available_bosses = []

	if bosses.size() == 0:
		return false
	
	# if cheapest boss can't be bought exit
	if bosses[-1].data.cost >= remaining_money:
		return false

	# get all bosses that can be bought
	for boss in bosses:
		if can_buy_trash(boss.data.cost, 2):
			available_bosses.append(boss)
	
	# if no bosses can be bought exit
	if available_bosses.size() == 0:
		return false
	
	# pick random boss and buy it
	var boss = available_bosses[randi_range(0, available_bosses.size() - 1)]
	remaining_money -= boss.data.cost
	ambush.append(boss)
	boss_bought = true

	return true


func reset_variables() -> void:
	monsters = {}

	savagery = 0

	debug = GameData.ambush_debug

	money = 0

	player_world_pos = Vector2i.ZERO

	ambush = []
	remaining_money = 0
	sorted_monsters = []
	boss_bought = false
