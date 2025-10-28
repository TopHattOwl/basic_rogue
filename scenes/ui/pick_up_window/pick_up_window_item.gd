
class_name PickUpWindowItemControlNode
extends Control

signal item_clicked(index: int)

var item_reference: ItemResource
var index: int
var is_selected: bool = false

var background: ColorRect
var icon: ColorRect
var label: Label

func setup(item: ItemResource, item_height: int, width: int, item_index: int) -> void:
	item_reference = item
	index = item_index
	custom_minimum_size = Vector2(width, item_height)
	
	# Background for selection highlight
	background = ColorRect.new()
	background.color = Color.TRANSPARENT
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	
	# HBox for layout
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)
	hbox.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(hbox)
	
	# Icon
	icon = ColorRect.new()
	icon.custom_minimum_size = Vector2(item_height, item_height)
	icon.color = Color(0.5, 0.5, 0.5)
	icon.mouse_filter = Control.MOUSE_FILTER_PASS
	hbox.add_child(icon)
	
	# Label
	label = Label.new()
	label.text = item.display_name
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.85))
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.mouse_filter = Control.MOUSE_FILTER_PASS
	hbox.add_child(label)

	# amount
	var label2 := Label.new()
	label2.text = " x" + str(item.get_component(StackableComponent).count)
	label2.add_theme_font_size_override("font_size", 8)
	label2.add_theme_color_override("font_color", Color(0.9, 0.9, 0.85))
	label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label2.name = "AmountLabel"
	hbox.add_child(label2)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			item_clicked.emit(index)
			accept_event()

func set_selected(selected: bool) -> void:
	is_selected = selected
	if selected:
		background.color = Color(0.3, 0.3, 0.3, 0.5)
		label.add_theme_color_override("font_color", Color(1.0, 1.0, 0.9))
	else:
		background.color = Color.TRANSPARENT
		label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.85))
