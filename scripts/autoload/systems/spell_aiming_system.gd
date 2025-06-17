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
	pass

## Enters spell aiming mode
## Player's targeter is turned off until player's input mode is restored to previous mode automatically in targeter's script
func enter_spell_aiming(_spell:  SpellNode) -> void:
	is_active = true
	set_process(is_active)

	# duplicate spell so player can cast it multiple times, without affecting original spell
	current_spell = _spell.duplicate()


	# determine spell type and use correct targeting module
	# for now just test if works
	var spell_aiming_targeter = SpellAimingTargeter.new(10)
	spell_aiming_targeter.activate()


	if GameData.spell_debug:
		print("--- SpellAimingSystem entered ---")
		print("spell aiming mode for spell: ", current_spell.uid)




func cast_spell(_target_grid: Vector2i) -> void:
	
	if GameData.spell_debug:
		print("SpellAimingSystem: calling spell's cast_spell for spell: ", current_spell.uid)
	
	current_spell.cast_spell(GameData.player, _target_grid)

	exit_spell_aiming()




## Exits spell aiming mode
## only runs when spell aiming was successfull so make turn end
func exit_spell_aiming() -> void:
	is_active = false
	set_process(is_active)


	if GameData.spell_debug:
		print("exiting spell aiming mode")


	# enter previous input mode
	GameData.player.PlayerComp.restore_input_mode()

	SignalBus.make_turn_pass.emit()