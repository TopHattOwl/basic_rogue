extends Node



enum TURN_PHASES {
	PLAYER,
	PROJECTILES,
	MONSTERS,
}

var current_turn_phase: int = TURN_PHASES.PLAYER

var active_projectiles: Array = []

var queued_actions: Array = []

func _ready() -> void:
	SignalBus.mkae_turn_pass.connect(_on_turn_pass_requested)
	SignalBus.projectile_spawned.connect(_on_projectile_spawned)
	SignalBus.projectile_finished.connect(_on_projectile_finished)


func process_turn():
	pass

# Player turn handlers
func _process_player_turn():
	# Player is already acting, just wait for actions
	pass

# Projectile turn handlers
func _process_projectiles():
	if active_projectiles.is_empty():
		advance_turn()
		return
	
	# Process each projectile
	for projectile in active_projectiles.duplicate():
		if is_instance_valid(projectile):
			projectile.process_turn()
		else:
			active_projectiles.erase(projectile)
	
	# Projectiles always complete in one cycle
	advance_turn()


func advance_turn():
	current_turn_phase = (current_turn_phase + 1) % TURN_PHASES.size()


# Signal handlers

func _on_turn_pass_requested():
	pass

func _on_projectile_spawned():
	pass

func _on_projectile_finished():
	pass



# 1. turn maanger
# TurnManager.gd
# extends Node

# enum TURN_PHASE { PLAYER, PROJECTILES, HOSTILES }
# var current_phase = TURN_PHASE.PLAYER
# var active_projectiles: Array = []

# # Initialize as autoload singleton (add in project settings)

# func _ready():
#     SignalBus.make_turn_pass.connect(_on_make_turn_pass)
#     SignalBus.projectile_created.connect(_on_projectile_created)
#     SignalBus.projectile_finished.connect(_on_projectile_finished)

# func _on_make_turn_pass():
#     # End player turn and start projectile phase
#     current_phase = TURN_PHASE.PROJECTILES
#     _process_projectiles()

# func _on_projectile_created(projectile):
#     active_projectiles.append(projectile)

# func _on_projectile_finished(projectile):
#     if projectile in active_projectiles:
#         active_projectiles.erase(projectile)

# func _process_projectiles():
#     if active_projectiles.is_empty():
#         # No projectiles, move directly to hostiles
#         _process_hostiles()
#         return
    
#     # Process each projectile
#     for projectile in active_projectiles.duplicate():
#         if is_instance_valid(projectile):
#             projectile.process_turn()
    
#     # Continue processing next frame
#     call_deferred("_process_hostiles")

# func _process_hostiles():
#     current_phase = TURN_PHASE.HOSTILES
    
#     # Get player position before any movement
#     var player_pos = ComponentRegistry.get_player_pos()
    
#     for enemy in GameData.all_hostile_actors.duplicate():
#         if not is_instance_valid(enemy):
#             GameData.all_hostile_actors.erase(enemy)
#             continue
            
#         var ai = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.AI_BEHAVIOR)
#         var enemy_pos = ComponentRegistry.get_component(enemy, GameData.ComponentKeys.POSITION).grid_pos
        
#         if ai.is_in_range(player_pos, enemy_pos):
#             var target_pos = ai.get_next_position(enemy_pos, player_pos)
#             MovementSystem.process_monster_movement(enemy, target_pos)
    
#     # Hostile turn complete, start new player turn
#     current_phase = TURN_PHASE.PLAYER
#     SignalBus.player_acted.emit()
#     ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = true

# 2. spell modification

# ProjectileSpell.gd
# class_name ProjectileSpell
# extends Node2D

# # Add this to your existing projectile class
# func process_turn():
#     # ... your movement and collision logic ...
    
#     # After moving, check if finished
#     if hit_something || reached_max_range:
#         SignalBus.projectile_finished.emit(self)
#         queue_free()

# 3. Spell Casting Modification
# In your spell casting function
# func cast_spell(spell: SpellResource, target_grid: Vector2i) -> bool:
#     # ... existing validation ...
    
#     # Create projectile instance
#     var projectile = preload("res://spells/ProjectileSpell.tscn").instantiate()
#     projectile.initialize(spell, caster, target_grid)
#     get_tree().current_scene.add_child(projectile)
    
#     # Notify turn manager
#     SignalBus.projectile_created.emit(projectile)
    
#     # Emit turn pass signal (starts projectile phase)
#     SignalBus.make_turn_pass.emit()
    
#     return true


# 4. signal bus additions

# # Add to SignalBus.gd
# signal projectile_created(projectile)
# signal projectile_finished(projectile)

# 5. Input Manager Modification

# # Modify _end_player_turn function
# func _end_player_turn() -> void:
#     # Only disable player input, don't process hostiles yet
#     ComponentRegistry.get_player_comp(GameData.ComponentKeys.PLAYER).is_players_turn = false
#     _input_states.clear()
    
#     # Don't process hostiles here - TurnManager will handle it

# 6. Main Node Process Update

# func _process(_delta):
#     if GameData.player.PlayerComp.is_players_turn:
#         input_manager.handle_input()

# 7. diagram code

# sequenceDiagram
#     participant Player
#     participant InputManager
#     participant TurnManager
#     participant Projectile
#     participant Hostiles
    
#     Player->>InputManager: Performs action (move/attack/spell)
#     InputManager->>TurnManager: make_turn_pass.emit()
#     TurnManager->>TurnManager: current_phase = PROJECTILES
#     loop For each projectile
#         TurnManager->>Projectile: process_turn()
#         Projectile->>Projectile: Move and check collisions
#         Projectile->>TurnManager: projectile_finished.emit()
#     end
#     TurnManager->>TurnManager: current_phase = HOSTILES
#     loop For each hostile
#         TurnManager->>Hostiles: Take turn
#     end
#     TurnManager->>TurnManager: current_phase = PLAYER
#     TurnManager->>Player: Enable player input