extends Node
## Spell aiming flow: [br]
	## when player is on zoomed in map and presses a hotbar button where a spell is then: [br]
	## Input manager will set prev input mode and calls HotbarComponent's use_hotbar func on the spell. [br]
	## use_hotbar will handle if SpellAimingSystem (this autoload) should be entered. [br]
## Entering SpellAimingSystem: [br]
	## SpellAimingSystem process is turned on and current_spell is set[br]
	## makes a new targeter module (SpellAimingTargeter) for spell and activates it: [br]
		## See SpellAimingTargeter for _init and activate func
## Exiting SpellAimingSystem: [br]
	## InputManager will handle exiting with esc button (restores prev input mode) [br]
	## Otherwise if spell is aimed to a correct tile, spell is cast by player -> emit make_turn_pass signal to process turn [br]

var is_active := false

var current_spell: SpellNode = null

var current_target_grid: Vector2i

var targeter: TargeterModule


var max_range: int

# this is from fov manager
var avalible_tiles: Array[Vector2i]


func _ready() -> void:
	set_process(is_active)

	SignalBus.directional_input.connect(_on_directional_input)

func _on_directional_input(dir: Vector2i):
	print("directional input: ", dir)

func _process(_delta: float) -> void:

	# updating position of targeter
	update_targeter_position()
	
	# spell casting
	if Input.is_action_just_pressed("click_left") or Input.is_action_just_pressed("enter"):
		print("Starting spell casting from SpellAimingSystem")
		cast_spell(current_target_grid)


func update_targeter_position():
	# set current target grid here and in targeter
	var mouse_pos = MapFunction.zoomed_in_mouse_pos
	current_target_grid = mouse_pos
	targeter.target_pos = current_target_grid

	# calculate targeter path
	var path: PackedVector2Array = MapFunction.get_line(ComponentRegistry.get_player_pos(), current_target_grid)
	path.remove_at(0)
	var path_vectori: Array[Vector2i] = []
	for grid in path:
		path_vectori.append(Vector2i(grid))
	targeter.add_path_line(path_vectori)

	# update visuals
	targeter.update_visuals()

## Enters spell aiming mode
## Player's targeter is turned off until player's input mode is restored to previous mode automatically in targeter's script
func enter_spell_aiming(_spell:  SpellNode) -> void:
	is_active = true
	

	# duplicate spell so player can cast it multiple times, without affecting original spell
	current_spell = _spell.duplicate()	

	# set boundaries for aiming
	var player_pos = ComponentRegistry.get_player_pos()
	var player_range = FovManager.player_vision_range
	var avalible_tiles = MapFunction.get_tiles_in_radius(player_pos, player_range, true)

	# determine spell type and use correct targeting module
	# for now just test if works
	var spell_aiming_targeter = SpellAimingTargeter.new(avalible_tiles)
	spell_aiming_targeter.activate()


	set_process(is_active)

	if GameData.spell_debug:
		print("--- SpellAimingSystem entered ---")
		print("spell aiming mode for spell: ", current_spell.uid)




func cast_spell(_target_grid: Vector2i) -> void:
	
	if GameData.spell_debug:
		print("SpellAimingSystem: calling spell's cast_spell for spell: ", current_spell.uid)
	
	current_spell.cast_spell(GameData.player, _target_grid)

	exit_spell_aiming(true)




## Exits spell aiming mode. [br]
## if `param is_success` is true then turn is passed
func exit_spell_aiming(is_success: bool) -> void:
	is_active = false
	set_process(is_active)


	if GameData.spell_debug:
		print("exiting spell aiming mode")


	# enter previous input mode
	GameData.player.PlayerComp.restore_input_mode()

	if targeter:
		targeter.queue_free()

	# if casting is successfull make turn pass
	if is_success:
		SignalBus.make_turn_pass.emit()
