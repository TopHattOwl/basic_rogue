class_name HotbarComponent
extends Node
# several hotbars
# player can cycle through hotbars

var active_hotbar_index: int = 0

var hotbar0: Dictionary = {
	"hotbar_1": {},
	"hotbar_2": {},
	"hotbar_3": {},
	"hotbar_4": {},
	"hotbar_5": {},
	"hotbar_6": {},
	"hotbar_7": {},
	"hotbar_8": {},
	"hotbar_9": {},
	"hotbar_0": {},
}

var hotbar1: Dictionary = {
	"hotbar_1": {},
	"hotbar_2": {},
	"hotbar_3": {},
	"hotbar_4": {},
	"hotbar_5": {},
	"hotbar_6": {},
	"hotbar_7": {},
	"hotbar_8": {},
	"hotbar_9": {},
	"hotbar_0": {},
}

var hotbar2: Dictionary = {
	"hotbar_1": {},
	"hotbar_2": {},
	"hotbar_3": {},
	"hotbar_4": {},
	"hotbar_5": {},
	"hotbar_6": {},
	"hotbar_7": {},
	"hotbar_8": {},
	"hotbar_9": {},
	"hotbar_0": {},
}

var hotbar3: Dictionary = {
	"hotbar_1": {},
	"hotbar_2": {},
	"hotbar_3": {},
	"hotbar_4": {},
	"hotbar_5": {},
	"hotbar_6": {},
	"hotbar_7": {},
	"hotbar_8": {},
	"hotbar_9": {},
	"hotbar_0": {},
}

var hotbars: Array = [hotbar0, hotbar1, hotbar2, hotbar3]

# hotbar structure
# kay is name of input, value is a dict where key is what type of node is in the hotbar position
#
# var hotbar_template {
#	 "hotbar_1": {
#		 "spell": uid
#	 }
#	 "hotbar_2": {
#		 "ability": uid
#	 }
# }

func _ready() -> void:
	active_hotbar_index = 0
	update_ui()

func update_ui():
	pass

func build_hotbar() -> void:
	pass


## adds thing to hotbar. [br]
## type: "spell", "ability" [br]
## uid is thing's uid like "fire_slash"
func add_to_hotbar(type: String, uid: String, hotbar_position: String) -> void:

	var data = {type: uid}

	var hotbar = hotbars[active_hotbar_index]

	hotbar[hotbar_position] = data


func use_hotbar(hotbar_input: String) -> void:

	var active_hotbar = hotbars[active_hotbar_index]

	if GameData.hot_bar_debug:
		print("using hotbar input: {0} on hotbar {1}".format([hotbar_input, active_hotbar_index]))

		print("type: {0}, uid: {1}".format([hotbar_input, hotbars[active_hotbar_index][hotbar_input]]))

	# check if hotbar position is empty
	if !active_hotbar[hotbar_input]:
		if GameData.hot_bar_debug:
			print("nothing on hotbar at position: {0}".format([hotbar_input]))
		return

	var type = active_hotbar[hotbar_input].keys()[0]
	var uid = active_hotbar[hotbar_input].values()[0]

	match type:
		"spell":
			use_spell(uid)
		"ability":
			use_ability(uid)
		_:
			push_error("unknown hotbar type: {0}".format([type]))
	

## Uses the spell from the hotbar. [br]
## If it needs to be aimed enter aiming mode (change play input mode) [br]
## if no aiming required cast spell
func use_spell(uid: String) -> void:
	var spells_comp: SpellsComponent = ComponentRegistry.get_player_comp(GameData.ComponentKeys.SPELLS)

	var spell = spells_comp.learnt_spells.get(uid, null)

	if !spell:
		push_error("used spell is not learned")

		return
	

	# if spell needs no aiming then cast it
	if !spell.spell_data.needs_aiming:
		spell.cast_spell(GameData.player)

		return
	
	# if spell needs aiming then enter aiming mode
	GameData.player.PlayerComp.input_mode = GameData.INPUT_MODES.SPELL_AIMING
	SpellAimingSystem.enter_spell_aiming(spell)

	# spell_to_be_cast = spell




func use_ability(uid: String) -> void:
	pass
