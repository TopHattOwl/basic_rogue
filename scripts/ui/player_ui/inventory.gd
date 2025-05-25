extends Control


# filled in godot engine, holds all the filter buttons in order
@export var FilterButtons: Array[Button]


func toggle_inventory() -> void:
	visible = !visible

	set_process(visible)

func _ready() -> void:
	# connect filter buttons to pressed signal
	for button in FilterButtons:
		button.pressed.connect(_on_filter_button_pressed.bind(FilterButtons.find(button)))


func _process(delta: float) -> void:
	pass


func _on_filter_button_pressed(index: int) -> void:
	print("pressed filter button index: ", index)
	print("pressed filter button name: ", FilterButtons[index].text)
