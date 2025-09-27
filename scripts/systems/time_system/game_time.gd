extends Node

const DAY_LENGTH = 2400 # a day in turns
const MONTH_LENGTH = 28 # a month in days
const YEAR_LENGTH = 14 # a year in months

@export var current_time: StringName
@export var current_day_turn: int = 750

@export var year: int = 853
@export var month: int = 4
@export var day: int = 12

var clock_rotation: float


# one day is 2400 turns -> 100 turns is an hour
var time_cycle: Dictionary = {
	"morning": 600, # start time
	"day": 1000,
	"evening": 1800,
	"night": 2200,
}

const MONTHS = {
	1: "first month",
	2: "second month",
	3: "third month",
	4: "fourth month",
	5: "fifth month",
	6: "sixth month",
	7: "seventh month",
	8: "eighth month",
	9: "ninth month",
	10: "tenth month",
	11: "eleventh month",
	12: "twelfth month",
	13: "thirteenth month",
	14: "fourteenth month",
}

## day names by week
# CONST DAYS = {

# }

var current_month: StringName

func _ready() -> void:
	current_month = MONTHS.get(month)
	SignalBus.player_acted.connect(_on_turn_end)
	update_current_time()

func _process(_delta: float) -> void:
	update_current_time()

	check_end_of_day()


## returns a dictionary with year, month and day at the time of the call
func get_date() -> Dictionary:
	return {
		"year": year,
		"month": month,
		"day": day
	}

func update_current_time():
	if current_day_turn >= time_cycle.morning and current_day_turn < time_cycle.day:
		current_time = "morning"
	elif current_day_turn >= time_cycle.day and current_day_turn < time_cycle.evening:
		current_time = "day"
	elif current_day_turn >= time_cycle.evening and current_day_turn < time_cycle.night:
		current_time = "evening"
	elif current_day_turn >= time_cycle.night:
		current_time = "night"
	elif current_day_turn < time_cycle.morning:
		current_time = "night"

func check_end_of_day():
	if current_day_turn >= DAY_LENGTH:
		current_day_turn = 0
		pass_day()

func pass_day():
	day += 1

	SignalBus.day_passed.emit()

	if day > MONTH_LENGTH:
		month += 1
		day = 1
		SignalBus.month_passed.emit()
	
	if month > YEAR_LENGTH:
		year += 1
		month = 1
		current_month = MONTHS.get(month)
		SignalBus.year_passed.emit()

func _on_turn_end() -> void:
	current_day_turn += 1
	
