extends Node


@export var current_time: StringName
@export var current_day_turn: int

@export var year: int = 853
@export var month: int = 4
@export var day: int = 12

# one day is 2400 turns -> 100 turns is an hour
var time_cycle: Dictionary = {
	"morning": 300, # start time
	"day": 1000,
	"evening": 1800,
	"night": 2200,
}

func _ready() -> void:
	SignalBus.player_acted.connect(_on_turn_end)

func _process(_delta: float) -> void:
	update_current_time()

	check_end_of_day()

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
	if current_day_turn == 2400:
		current_day_turn = 0
		pass_day()

func pass_day():
	day += 1

	if day == 30:
		month += 1
		day = 1
	
	if month == 15:
		year += 1
		month = 1

func _on_turn_end() -> void:
	current_day_turn += 1
	
