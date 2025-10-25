extends Node
## turn phases go in order



enum TURN_PHASES {
	PLAYER,
	PROJECTILES,
	MONSTERS,
	TURN_END,
}

var current_turn_phase: int = TURN_PHASES.PLAYER

var active_projectiles: Array = []

func _ready() -> void:
	SignalBus.make_turn_pass.connect(_on_make_turn_pass)
	SignalBus.projectile_spawned.connect(_on_projectile_spawned)
	SignalBus.projectile_finished.connect(_on_projectile_finished)

# --- TURN END HANDELERS ---

func _process_turn_end():
	if GameData.turn_manager_debug:
		print("processing turn end phase")
	# Player is already acting, just wait for actions

	SignalBus.player_acted.emit()
	ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true


# --- PLAYER TURN HANDLERS ---
func _process_player_turn():

	# TODO implement acton queues for movement and pass turns (to pass several turns)

	call_deferred("advance_turn_phase")

# --- PROJECTILE TURN HANDLERS ----
func _process_projectiles():
	if GameData.turn_manager_debug:
		print("processing projectiles phase")

	# if no projectiles go to next turn immediately
	if active_projectiles.is_empty():
		advance_turn_phase()
		return
	
	# Process each projectile
	for projectile in active_projectiles.duplicate():
		if is_instance_valid(projectile):
			projectile.process_turn()
		else:
			active_projectiles.erase(projectile)
	
	# Projectiles always complete in one cycle
	call_deferred("advance_turn_phase")
	

# --- MONSTER TURN HANDLER ---

func _process_monsters():

	if GameData.turn_manager_debug:
		print("processing monsters phase")

	var player_pos = ComponentRegistry.get_player_pos()


	for enemy in GameData.all_hostile_actors:
		var ai = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.AI_BEHAVIOR)
		var enemy_pos = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.POSITION).grid_pos



		if ai.is_in_range(player_pos, enemy_pos):

			var target_pos = ai.get_next_position(enemy_pos, player_pos)
			MovementSystem.process_monster_movement(enemy, target_pos)
		else:
			# handle other ai here, if player is not in vision
			pass

	call_deferred("advance_turn_phase")


# --- SIGNAL HANDLERS ---
func _on_make_turn_pass():
	if GameData.turn_manager_debug:
		print("--- processing turn pass in turn manager ---")

	# advance the turn, the start phase is PLAYER
	# maybe have to change to call_deferred() idk
	advance_turn_phase()

func _on_projectile_spawned(d: Dictionary):
	var spell = d.get("spell", null)

	if spell:
		active_projectiles.append(spell)


func _on_projectile_finished(d: Dictionary):
	var spell = d.get("spell", null)
	
	if spell:
		if spell in active_projectiles:
			active_projectiles.erase(spell)


# --- UTILS ---

func advance_turn_phase():
	current_turn_phase = (current_turn_phase + 1) % TURN_PHASES.size()

	if GameData.turn_manager_debug:
		print("advancing turn phase")

	match current_turn_phase:
		TURN_PHASES.PLAYER:
			_process_player_turn()
		TURN_PHASES.PROJECTILES:
			_process_projectiles()
		TURN_PHASES.MONSTERS:
			_process_monsters()
		TURN_PHASES.TURN_END:
			_process_turn_end()
