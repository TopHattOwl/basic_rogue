extends Node
## when player enters a world map tile amush manager creates ambushes depending on savagery, monster tiers, and other factors maybe
## replaces fixed spawn points in WorldMonsterTile


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
var miniboss_count: int


# TODO: make boss chance a calculation (savagery and time based maybe)
#		also make max miniboss amount a calculation
const BOSS_CHANCE: float = 0.5
const MINIBOSS_MAX: int = 3

func _ready() -> void:
	SignalBus.world_node_ready.connect(_on_world_node_ready)
	debug = GameData.ambush_debug


func _on_world_node_ready() -> void:
	reset_variables()
	var monster_names = [] # for debug

	player_world_pos = GameData.player.PlayerComp.world_map_pos

	monsters = MonsterDefinitions.get_avalible_monsters(WorldMapData.biome_map.get_biome_type(player_world_pos))
	savagery = WorldMapData.world_map_savagery[player_world_pos.y][player_world_pos.x]

	if savagery == 0:
		if debug:
			print("--- AMBUSH MANAGER ---")
			print("\t-- no savagery --")
			print("--- AMBUSH MANAGER END ---")
		return

	if ActionHistory.been_in_dungeon(50):
		if debug:
			print("--- AMBUSH MANAGER ---")
			print("\t-- player came from dungeon, no ambush --")
			print("--- AMBUSH MANAGER END ---")
		return
	
	var ambush_chance: float = clampf((float(savagery) / 10) * 0.4 * TimeDifficulty.ambush_chance_multiplier, 0, 0.75)

	if debug:
		print("--- AMBUSH MANAGER ---")
		print("monster ids: ", monsters.keys())

		print("monsters data:")
		for monster in monsters.keys():
			print("\t", monsters[monster])
		print("chance for ambush: ", ambush_chance)


	if randf() > ambush_chance:
		if debug:	
			print("\t --no ambush --")
			print("--- AMBUSH MANAGER END ---")
		return
	
	if debug:
		print("\t-- ambush --")

	# getting spawin points

	var random_grid = Vector2i(
		randi_range(GameData.MAP_SIZE.x / 4, GameData.MAP_SIZE.x - GameData.MAP_SIZE.x / 4),
		randi_range(GameData.MAP_SIZE.y / 4, GameData.MAP_SIZE.y - GameData.MAP_SIZE.y / 4)
	)

	var available_spawns: Array = MapFunction.get_tiles_in_radius(random_grid, 7, false, true, "chebyshev", true, true)
	calc_money()
	remaining_money = money
	sorted_monsters = sort_monster()
	boss_bought = false

	make_ambush()

	spawn_ambush(available_spawns)

	# DEBUG END PRINT
	var minibosses = ambush.filter(func(monster): return monster.data.type == MonsterDefinitions.MONSTER_TYPES.MINIBOSS)
	monster_names = ambush.map(func(monster): return monster.data.uid)
	if debug:
		print("\t\t______ SUMMARY ______")
		print("sorted monster:\n")
		for monster in sorted_monsters:
			print("\t", monster)
		print("Ambush manager money:\n", money)
		print("Spent money:\n", money - remaining_money)
		print("Spawned monsters' names:\n\t", monster_names)

		print("Boss:")
		if boss_bought:
			print("\tboss spawned")
			print("\t", ambush[0])
		else:
			print("\tboss not spawned")
		print("minibosses:")
		for miniboss in minibosses:
			print("\t", miniboss)
		print("Ambush:")
		for monster in ambush:
			print("\t", monster)
		print("--- AMBUSH MANAGER END ---")


# --- BUYING and MONSTERS ---


func make_ambush() -> void:
	if not try_buy_boss():
		try_buy_miniboss()
		
	
	spend_remaining_money()


## Spawns all monsters in the ambush
func spawn_ambush(spawn_zone: Array) -> void:

	if debug:
		print("\t---SPAWNING AMBUSH---")

	for monster in ambush:
		if spawn_zone.size() == 0:
			break

		# get random pos, then remove that pos from spawn_zone
		var random_pos = spawn_zone[randi_range(0, spawn_zone.size() - 1)]
		spawn_zone.erase(random_pos)

		EntitySpawner.spawn_monster(random_pos, monster.data.id)

		if debug:
			print("Spawning " + monster.data.uid + " at: " + "(" + str(random_pos.x) + ", " + str(random_pos.y) + ")")

	
## Tries buying a boss [br]
func try_buy_boss() -> bool:

	if boss_bought:
		return false

	# chance to get boss
	if randf() > BOSS_CHANCE:
		return false

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
	buy_monster(boss)

	return true


func try_buy_miniboss() -> bool:

	if miniboss_count >= MINIBOSS_MAX:
		return false

	var minibosses = sorted_monsters.filter(func(monster): return monster.data.type == MonsterDefinitions.MONSTER_TYPES.MINIBOSS)
	var available_minibosses = []

	if minibosses.size() == 0:
		return false
	
	if minibosses[-1].data.cost >= remaining_money:
		return false

	for miniboss in minibosses:
		if can_buy_trash(miniboss.data.cost, 1):
			available_minibosses.append(miniboss)
	
	if available_minibosses.size() == 0:
		return false
	
	var miniboss = available_minibosses[randi_range(0, available_minibosses.size() - 1)]
	buy_monster(miniboss)
	return true

func spend_remaining_money() -> void:

	# remove bosses from monsters list
	var monsters_to_buy: Array = sorted_monsters.filter(func(monster): return monster.data.type != MonsterDefinitions.MONSTER_TYPES.BOSS)

	if debug:
		print("--- SPENDING REMAINING MONEY ---")
		print("remaining money:\n", remaining_money)
		print("monsters to buy:")
		for monster in monsters_to_buy:
			print("\t", monster)

	while remaining_money > 0:

		var affordable = monsters_to_buy.filter(func(monster): return monster.data.cost <= remaining_money)

		if debug:
			print("affordable:")
			for monster in affordable:
				print("\t", monster)

		if affordable.size() == 0:
			if debug:
				print("no affordable monsters")
				print("--- SPENDING REMAINING MONEY END ---")
			break


		var monster_shopping_cart: Array = []

		if affordable.size() <= 3:
			monster_shopping_cart = affordable
		else:
			monster_shopping_cart = affordable.slice(0, affordable.size() / 2)
		
		var random_monster = monster_shopping_cart[randi_range(0, monster_shopping_cart.size() - 1)]
		buy_monster(random_monster)

	
		if debug:
			print("bought a random monster from monster shopping cart:")
			for monster in monster_shopping_cart:
				if monster == random_monster:
					print("\t" + str(monster) + " <--- BOUGHT")
				else:
					print("\t", monster)
			print("--- SPENDING REMAINING MONEY END ---")		
		


## Buys a monster and adds it to the ambush Array [br]
## Remaining money is reduced
func buy_monster(monster: Dictionary) -> void:

	remaining_money -= monster.data.cost
	ambush.append(monster)

	if monster.data.type == MonsterDefinitions.MONSTER_TYPES.BOSS:
		boss_bought = true

	if monster.data.type == MonsterDefinitions.MONSTER_TYPES.MINIBOSS:
		miniboss_count += 1

	if debug:
		print("\t __ BUYING MONSTER __")
		print("\tmonster: ", monster)
		print("\tremaining money after buy: ", remaining_money)
		print("\t __ BUYING MONSTER END __")


# --- UTILS ---


## Sorts monsters buy cost, descending
func sort_monster() -> Array:
	var _sorted_monsters = []

	for monster_id in monsters.keys():
		_sorted_monsters.append({
			"id": monster_id,
			"data": monsters[monster_id]
		})
	
	_sorted_monsters.sort_custom(func(a, b): return a.data.cost > b.data.cost)

	return _sorted_monsters


## checks if ambush manager can buy some trash monsters after buying a boss/miniboss
func can_buy_trash(to_be_bought_cost: int, num_of_trash: int) -> bool:
	if debug:
		print("\t--- CAN BUY TRASH ---")
		print("to be bought cost: ", to_be_bought_cost)
		print("remaining money: ", remaining_money)
		print("num of trash: ", num_of_trash)
	
	var money_after_buy = remaining_money - to_be_bought_cost

	var lowest_cost = sorted_monsters[-1].data.cost

	if lowest_cost * num_of_trash > money_after_buy:
		if debug:
			print("lowest cost * num of trash is higher than money after buy")
			print("\t--- CAN BUY TRASH END ---")
		return false 

	if debug:
		print("monster can be bought")
		print("\t--- CAN BUY TRASH END ---")
	return true


func calc_money() -> void:
	var _money = floori(float(savagery) * 3.5 * TimeDifficulty.ambush_money_multiplier)

	# randomness
	_money = randi_range(_money * 0.8, _money * 1.2)

	money = _money


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
	miniboss_count = 0
