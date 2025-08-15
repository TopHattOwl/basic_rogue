extends CanvasLayer


@onready var input_field: LineEdit = $InputField
@onready var output_field: RichTextLabel = $OutputField


# implement max history size
const MAX_HISTORY_SIZE = 25

var command_history: Array[String] = []
var history_index = 0


func _ready() -> void:
	# input_field.
	hide_console()
	input_field.connect("text_submitted", _on_input_submitted)


	make_base_text()


func _process(_delta: float) -> void:
	input_field.grab_focus()

	if Input.is_action_just_pressed("console"):
		GameData.player.PlayerComp.restore_input_mode()
		toggle_console()

	if Input.is_action_just_pressed("ui_up"):
		navigate_history(-1)
	elif Input.is_action_just_pressed("ui_down"):
		navigate_history(1)


func make_base_text() -> void:
	output_field.clear()
	var txt = "\n-----CONSOLE-----\nType 'help' to see available commands\n"

	output_field.append_text(txt)


# --- Visibility ---

func toggle_console():
	if visible:
		hide_console()
	else:
		show_console()

func hide_console():
	visible = false
	set_process(false)

func show_console():
	set_process(true)
	visible = true
	input_field.grab_focus()
	input_field.clear()


# --- Input processing ---
func _on_input_submitted(text: String) -> void:
	var _text = text.strip_edges()
	if _text.is_empty():
		input_field.grab_focus()
		return


	add_command_history(_text)
	output_field.append_text("\n>>>" + _text)
	input_field.grab_focus()

	var result = ConsoleSystem.execute_command(_text)
	output_field.append_text("\n" + result)

	output_field.scroll_to_line(output_field.get_line_count()) # auto-scroll


func navigate_history(dir: int) -> void:
	if command_history.is_empty():
		return
	
	history_index = clampi(history_index + dir, 0, command_history.size())

	if history_index < command_history.size():
		input_field.text = command_history[history_index]
		input_field.caret_column = input_field.text.length() 
	else:
		input_field.clear()


func add_command_history(text: String) -> void:
	command_history.append(text)
	history_index = command_history.size()
	input_field.clear()
	
