
class_name PickUpWindowControlNode
extends Control

const ITEM_HEIGHT: int = 10
const WIDTH: int = 144
const MAX_HEIGHT: int = 220
const PADDING: int = 16
const V_BOX_SEPARATION: int = 2
const BORDER_WIDTH: int = 2

var gather_pos: Vector2i

var item_v_container: VBoxContainer
var items_to_display: Array = [] # reference to items in GameData.items_map
var item_controls: Array[PickUpWindowItemControlNode] = []
var selected_index: int = 0
var take_all_button: Button

func _ready() -> void:
	build_ui()
	
	# Wait one frame for size calculation
	await get_tree().process_frame
	
	# center it
	var viewport_size: Vector2 = get_viewport_rect().size
	position = Vector2(
		(viewport_size.x / 2 - size.x / 2),
		(viewport_size.y / 2 - size.y / 2)
	)

	# only set visible to true when all is ready
	visible = true

func _process(_delta: float) -> void:
	# exit
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()

	# cycle
	if Input.is_action_just_pressed("ui_up_custom"):
		cycle_selection(-1)
		get_viewport().set_input_as_handled()
	if Input.is_action_just_pressed("ui_down_custom"):
		cycle_selection(1)
		get_viewport().set_input_as_handled()


	# pick up
	if Input.is_action_just_pressed("ui_accept_custom"):
		pick_up_selected()
		get_viewport().set_input_as_handled()
	if Input.is_action_just_pressed("ui_tab_custom"):
		take_all()
		get_viewport().set_input_as_handled()


func cycle_selection(direction: int) -> void:
	if item_controls.is_empty():
		return
	
	selected_index = (selected_index + direction) % item_controls.size()
	if selected_index < 0:
		selected_index = item_controls.size() - 1
	
	select_item(selected_index)

func select_item(index: int) -> void:
	# Deselect all
	for item_control in item_controls:
		item_control.set_selected(false)
	
	# Select the chosen one
	if index >= 0 and index < item_controls.size():
		selected_index = index
		item_controls[index].set_selected(true)

func _on_item_clicked(index: int) -> void:
	pick_up_item(index)

func pick_up_selected() -> void:
	if selected_index >= 0 and selected_index < items_to_display.size():
		pick_up_item(selected_index)

func pick_up_item(index: int) -> void:
	if index < 0 or index >= items_to_display.size():
		return
	
	# adding the item to the entity's inventory
	ItemDropManager.pick_up_specific_item(items_to_display[index], gather_pos, GameData.player)

	# items_to_display here is only a reference to items inside GameData.items_map[grid_pos] so no tuching it here
	if items_to_display.is_empty():
		close_window()
		return
	# Remove from display
	item_controls[index].queue_free()
	item_controls.remove_at(index)

	
	# Update indices for remaining items
	for i in range(index, item_controls.size()):
		item_controls[i].index = i
	

	# Adjust selection
	if selected_index >= item_controls.size():
		selected_index = item_controls.size() - 1
	select_item(selected_index)
	

func take_all() -> void:
	ItemDropManager.pick_up_all_items(gather_pos, GameData.player)
	
	close_window()



func setup(items: Array = [], _gather_pos: Vector2i = Vector2i.ZERO) -> void:
	items_to_display = items
	gather_pos = _gather_pos
	
	z_as_relative = false
	z_index = GameData.PICK_UP_WINDOW_Z_INDEX

	# set visible to false so player can't see ui being resized n shit
	visible = false

func build_ui() -> void:

	# maybe needed idk
	# size = Vector2(WIDTH + PADDING * 2, items_to_display.size() * ITEM_HEIGHT + PADDING * 2)

	# root VBoxContainer for auto sizing
	var root_vbox := VBoxContainer.new()
	root_vbox.custom_minimum_size = Vector2(WIDTH + PADDING * 2 + BORDER_WIDTH * 2, 0)
	root_vbox.name = "RootVBoxContainer"
	add_child(root_vbox)
	
	# # Border panel for bg
	var border_panel := PanelContainer.new()
	# Create StyleBox for the border
	var border_style := StyleBoxFlat.new()
	border_style.bg_color = Color(255, 250, 241)  # Off-white border
	border_style.content_margin_left = BORDER_WIDTH
	border_style.content_margin_right = BORDER_WIDTH
	border_style.content_margin_top = BORDER_WIDTH
	border_style.content_margin_bottom = BORDER_WIDTH
	border_panel.add_theme_stylebox_override("panel", border_style)
	border_panel.name = "BorderPanel"
	root_vbox.add_child(border_panel)
	
	# Black background panel
	var background_panel := PanelContainer.new()
	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color.BLACK
	bg_style.content_margin_left = PADDING
	bg_style.content_margin_right = PADDING
	bg_style.content_margin_top = PADDING
	bg_style.content_margin_bottom = PADDING
	background_panel.add_theme_stylebox_override("panel", bg_style)
	background_panel.name = "BackgroundPanel"
	border_panel.add_child(background_panel)

	# TODO: replace `background_panel` and `border_panel` with themes panel
	# var background_panel := Panel.new()
	# background_panel.name = "BackgroundPanel"
	# background_panel.theme = load(DirectoryPaths.main_theme)
	# background_panel.size = size
	# root_vbox.add_child(background_panel)

	# main Vbox for items and button
	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", V_BOX_SEPARATION)
	main_vbox.name = "MainVBoxContainer"
	background_panel.add_child(main_vbox)
	
	# VBox for items
	item_v_container = VBoxContainer.new()
	item_v_container.add_theme_constant_override("separation", V_BOX_SEPARATION)
	item_v_container.name = "ItemVBoxContainer"
	main_vbox.add_child(item_v_container)
	

	for i in items_to_display.size():
		var item: ItemResource = items_to_display[i]
		var pick_up_window_item: PickUpWindowItemControlNode = PickUpWindowItemControlNode.new()
		pick_up_window_item.setup(item, ITEM_HEIGHT, WIDTH, i)
		pick_up_window_item.item_clicked.connect(_on_item_clicked)
		item_v_container.add_child(pick_up_window_item)
		item_controls.append(pick_up_window_item)

	
	# Take All button
	take_all_button = Button.new()
	take_all_button.text = "Take All [G/Tab]"
	take_all_button.custom_minimum_size = Vector2(WIDTH, ITEM_HEIGHT)
	take_all_button.add_theme_font_size_override("font_size", 8)

	# style
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.2, 0.2, 0.2)
	btn_style.border_color = Color(0.5, 0.5, 0.5)
	btn_style.set_border_width_all(1)
	take_all_button.add_theme_stylebox_override("normal", btn_style)
	
	# hover style
	var btn_hover := StyleBoxFlat.new()
	btn_hover.bg_color = Color(0.3, 0.3, 0.3)
	btn_hover.border_color = Color(0.7, 0.7, 0.7)
	btn_hover.set_border_width_all(1)
	take_all_button.add_theme_stylebox_override("hover", btn_hover)
	
	take_all_button.pressed.connect(take_all)
	main_vbox.add_child(take_all_button)


func close_window() -> void:
	GameData.player.PlayerComp.restore_input_mode()
	queue_free()
