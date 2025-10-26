extends Control

# offset for rotation of the clock to show correct time (0 degree rotation for the clock image is 12:00 -> need to offset it)
const rotation_offset: float = 180

@onready var clock = $Clock
@export var time_label: Label # label unter the clock that shows the current time of day



var degrees_per_turn: float

func _ready() -> void:
	# set label properties
	time_label.add_theme_font_size_override("font_size", 12)
	time_label.text = GameTime.current_time

	degrees_per_turn = 360.0 / float(GameTime.DAY_LENGTH)
	# print("one turn is ", degrees_per_turn, " degrees")
	SignalBus.turn_passed.connect(_on_player_acted)
	_on_player_acted()


func _on_player_acted() -> void:
	var _rotation_degrees = GameTime.current_day_turn * degrees_per_turn + rotation_offset
	clock.rotation_degrees = _rotation_degrees

	# update label
	time_label.text = GameTime.current_time
