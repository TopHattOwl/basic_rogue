class_name Contract
extends Resource

enum CONTRACT_TYPE {OWERWORLD, DUNGEON}
enum CONTRACT_STATE {AVAILABLE, IN_PROGRESS, READY_TO_TUNR_IN, COMPLETED, FAILED}

# general data
var contract_id: String
var settlement: SettlementTile # reference to the settlement
var contract_type: CONTRACT_TYPE
var title: String
var description: String
var difficulty: int = 1
var reward_gold: int = 50
var reward_items: Array[int] = []  # item IDs
var state: CONTRACT_STATE = CONTRACT_STATE.AVAILABLE


# owerworld data


# dungeon data
var target_dungeon_id: String = ""
var dungeon_objective: String = "" # "clear", "boss", "item", etc.


# time data
var generated_date: Dictionary #
# if a lot of time passes since it has been generated discard

var time_limit: int = 0  # in turns, 0 means no limit
var expiration_date: Array


var debug := GameData.contract_debug


func check() -> bool:
	return true

func _init(data: Dictionary) -> void:
	generated_date = GameTime.get_date()


func get_debug_info() -> String:
	var info = ""

	# title
	info += "- Title: %s\n" % title

	# settlement info
	info += "- Settlement: %s\n" % settlement.get_debug_info()

	# description
	info += "- Description: %s\n" % description

	return info
