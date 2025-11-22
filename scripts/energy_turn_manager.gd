class_name EnergyTurnManager
extends Node

var actor_queue: Array = []  # Sorted by energy descending [player ref, enemy 1 ref, npc 1 ref, turn_event ref]
var turn_event: TurnEvent

var active_projectiles: Array = []

var debug: int = GameData.energy_turn_manager_debug

func _ready():

	# add turn event to queue
	var _turn_event: TurnEvent = TurnEvent.new()
	turn_event = _turn_event
	add_to_queue(turn_event)


	SignalBus.actor_died.connect(remove_from_queue)
	SignalBus.actor_spawned.connect(add_to_queue)
	SignalBus.actor_removed.connect(remove_from_queue)
	SignalBus.player_action_completed.connect(on_player_action_completed)

	SignalBus.projectile_spawned.connect(_on_projectile_spawned)
	SignalBus.projectile_finished.connect(_on_projectile_finished)

	GameData.energy_turn_manager = self


func process_next_action():

	if debug:
		print("[EnergyTurnManager] ==== PROCESSING NEXT ACTION ====")

	if actor_queue.is_empty():
		if debug:
			print("[EnergyTurnManager] No actors in queue")
		return

	# get actor with lowest time value
	var actor: Node2D = actor_queue[0]
	var energy_comp: EnergyComponent = ComponentRegistry.get_component(actor, GameData.ComponentKeys.ENERGY)

	# turn event is next -> pass turn
	if actor == turn_event:
		if debug:
			print("[EnergyTurnManager] current actor is turn event -> passing turn")
		pass_turn()
		return
	
	# remove temporarily from queue
	actor_queue.remove_at(0)

	# special case for player
	if actor == GameData.player:
		if debug:
			print("[EnergyTurnManager] player's turn, waiting for input")
		var player_comp = GameData.player.PlayerComp
		player_comp.is_players_turn = true
		# don't readd to queue yet, wait for player input
		return
	
	# other actors
	if debug:
		print("[EnergyTurnManager] processing action for actor: ", actor.uid)
	var _action: Action = get_action(actor)
	if debug:
		print("\t\tAction: ", GameData.ACTIONS.keys()[_action.action_type])

	energy_comp.add_time(_action.cost)
	
	# if still alive add back
	if is_instance_valid(actor):
		if debug:
			print("[EnergyTurnManager] actor action processed, time value: ", energy_comp.time_value)
		add_to_queue(actor)
	else:
		if debug:
			print("[EnergyTurnManager] actior died from action")

func on_player_action_completed(_action: Action) -> void:

	var action_cost: int = _action.cost
	var energy_comp: EnergyComponent = GameData.player.EnergyComp

	if debug:
		print("[[EnergyTurnManager] player time value before action: ", energy_comp.time_value)
		print("[[EnergyTurnManager] cost of action: ", action_cost)
	energy_comp.add_time(action_cost)

	if debug:
		print("[EnergyTurnManager] player action completed, time value after action: ", energy_comp.time_value)
		print("\t\tAction: ", GameData.ACTIONS.keys()[_action.action_type])

	# add player back to queue if not in it
	if not actor_queue.has(GameData.player):
		add_to_queue(GameData.player)

	var player_comp: PlayerComponent = GameData.player.PlayerComp
	player_comp.is_players_turn = false
	GameData.input_manager._input_states.clear()

	# continue the turn processing
	process_next_action()

func pass_turn() -> void:

	if debug:
		print("===============================================")
		print("===   [EnergyTurnManager] PASSING TURN      ===")
		print("===============================================")
		print("[EnergyTurnManager]\tprocessing projectiles")

	_process_projectiles()

	turn_event.pass_turn()

	if debug:
		print("[EnergyTurnManager]\tTurnEvent time value: ", turn_event.get_time_value())

	SignalBus.turn_passed.emit()

	sort_actors()

## executes the actor's ai action and returns the action cost
func get_action(actor) -> Action:

	var ai: AiBehaviorComponent = ComponentRegistry.get_component(actor, GameData.ComponentKeys.AI_BEHAVIOR)

	# if actor has no ai, do nothing just wait
	if not ai:
		return ActionFactory.make_action({"entity": actor})

	var _action: Action = ai.execute_ai_action()
	return _action

func _process_projectiles() -> void:

	if debug:
		print("[EnergyTurnManager] processing projectiles phase")

	if active_projectiles.is_empty():
		return
	
	# Process each projectile
	for projectile in active_projectiles.duplicate():
		if is_instance_valid(projectile):
			projectile.process_turn()
		else:
			active_projectiles.erase(projectile)

# --- UTILS ---
func add_to_queue(actor: Node2D) -> void:
	var energy_comp: EnergyComponent = ComponentRegistry.get_component(actor, GameData.ComponentKeys.ENERGY)

	for i in range(actor_queue.size()):
		var queue_energy: EnergyComponent = ComponentRegistry.get_component(actor_queue[i], GameData.ComponentKeys.ENERGY)
		if energy_comp.time_value < queue_energy.time_value:
			actor_queue.insert(i, actor)
			return

	actor_queue.append(actor)

func remove_from_queue(actor: Node2D) -> void:
	actor_queue.erase(actor)

func sort_actors() -> void:
	actor_queue.sort_custom(func(a, b):
		var a_energy_comp: EnergyComponent = ComponentRegistry.get_component(a, GameData.ComponentKeys.ENERGY)
		var b_energy_comp: EnergyComponent = ComponentRegistry.get_component(b, GameData.ComponentKeys.ENERGY)
		return a_energy_comp.time_value < b_energy_comp.time_value
	)


func _on_projectile_spawned(d: Dictionary):
	var spell = d.get("spell", null)

	if spell:
		active_projectiles.append(spell)


func _on_projectile_finished(d: Dictionary):
	var spell = d.get("spell", null)
	
	if spell:
		if spell in active_projectiles:
			active_projectiles.erase(spell)
