extends Control


@export var stance_buttons: Array[Button] = []

@onready var stance_container: HBoxContainer = $StanceContainer
var current_stances: Array[Stance]

var is_shift_toggled := false

func _ready() -> void:
	visible = false
	make_stance_buttons()
	set_process(is_shift_toggled)
	

func toggle_stance_bar() -> void:
	visible = !visible
	is_shift_toggled = !is_shift_toggled

	# if toggling on make buttons
	if visible:
		make_stance_buttons()
	
	set_process(is_shift_toggled)

func _process(_delta: float) -> void:

	for i in range(stance_buttons.size()):
		if Input.is_action_just_pressed("stance_" + str(i + 1)):
			_activate_stance(i)


func make_stance_buttons():
	var stances = GameData.player.StanceComp.known_stances

	# clear the stance container
	for child in stance_container.get_children():
		child.queue_free()
	stance_buttons.clear()
	
	var index = 0
	var player_equipment = GameData.player.EquipmentComp
	var weapon = player_equipment.weapon
	
	for stance in stances:

		# check for weapon and armor type requirement -> only show stances that can be activated

		var container = Container.new()
		var button = Button.new()
		container.add_child(button)
		stance_container.add_child(container)
		button.tooltip_text = stance.name
		button.text = str(index + 1)
		button.icon = stance.icon
		stance_buttons.append(button)
		current_stances.append(stance)

		# make them look good
		container.size_flags_horizontal = SIZE_EXPAND_FILL
		button.size_flags_horizontal = SIZE_EXPAND_FILL

		# connect function
		button.pressed.connect(_activate_stance.bind(index))
		index += 1

func _activate_stance(index: int):
	if index < stance_buttons.size():
		var selected_stance = current_stances[index]
		print("stance selected: ", selected_stance.name)
		# TODO: set the player's current stance

		if !GameData.player.StanceComp.enter_stance(selected_stance):
			return

		# end player's turn and exit stance selection
		GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.ZOOMED_IN_MOVEMENT # only in zoomed in mode can player change stances so prev input was that for sure

		toggle_stance_bar()

		GameData.main_node.get_node("InputManager")._end_player_turn()
		