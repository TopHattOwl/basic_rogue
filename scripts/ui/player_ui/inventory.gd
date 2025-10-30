class_name InventoryControlNode
extends Control



# --- INVENTORY ---

var DEFAULT_TAB: int = GameData.ITEM_TYPES.WEAPON

# item filter buttons
var FilterButtons: Array[Button]

var TAB_ICONS = {
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.WEAPON]: load(DirectoryPaths.weapons_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.RANGED_WEAPON]: load(DirectoryPaths.ranged_weapons_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.SHIELD]: load(DirectoryPaths.shield_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.ARMOR]: load(DirectoryPaths.armor_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.POTION]: load(DirectoryPaths.potions_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.POWDER]: load(DirectoryPaths.powder_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.MONSTER_PART]: load(DirectoryPaths.monster_parts_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.ALCHEMY]: load(DirectoryPaths.alchemy_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.RESOURCE]: load(DirectoryPaths.resource_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.FOOD]: load(DirectoryPaths.food_tab_icon),
	GameData.ITEM_TAB_NAMES[GameData.ITEM_TYPES.OTHER]: load(DirectoryPaths.other_tab_icon),
}

@onready var filter_container = $FilterContainer
@onready var tab_name = $TabName

@onready var items_container = $ItemsContainer
var items_container_children: Array

var selected_index: int = 0


var current_tab = DEFAULT_TAB

var is_item_window_opened := false

func toggle_inventory() -> void:
	visible = !visible

	set_process(visible)

	if visible:
		SignalBus.inventory_opened.emit()
		_on_filter_button_pressed(DEFAULT_TAB)
		equipment_tab.scan_items()

	else:
		SignalBus.inventory_closed.emit()
		GameData.player.PlayerComp.restore_input_mode()


func _ready() -> void:
	SignalBus.inventory_update.connect(_update)
	SignalBus.item_window_opened.connect(_on_item_window_opened)
	SignalBus.item_window_closed.connect(_on_item_window_closed)

	make_inventory()
	connect_filter_buttons()

	# open default tab
	_on_filter_button_pressed(DEFAULT_TAB)


func _process(_delta: float) -> void:

	if not visible:
		return
	
	# if item window is openned let no input in
	if is_item_window_opened:
		return

	# tab filter
	if Input.is_action_just_pressed("ui_inventory_next_tab"):
		_on_filter_button_pressed((current_tab + 1) % GameData.ITEM_TAB_NAMES.size())

	if Input.is_action_just_pressed("ui_inventory_prev_tab"):
		if current_tab == 0:
			_on_filter_button_pressed(GameData.ITEM_TAB_NAMES.size() - 1)
		else:
			_on_filter_button_pressed((current_tab - 1) % GameData.ITEM_TAB_NAMES.size())
	
	# cycle
	if Input.is_action_just_pressed("ui_up_custom"):
		pass
		cycle_items(-1)
		
	if Input.is_action_just_pressed("ui_down_custom"):
		pass
		cycle_items(1)
		

	if Input.is_action_just_pressed("ui_cancel"):
		if is_item_window_opened:
			return


func cycle_items(direction: int) -> void:
	if items_container_children.is_empty():
		return
	
	selected_index = (selected_index + direction) % items_container_children.size()
	if selected_index < 0:
		selected_index = items_container_children.size() - 1
	
	items_container_children[selected_index].select()


func _on_filter_button_pressed(index: int) -> void:
	clear_items()
	for button in FilterButtons:
		button.button_pressed = false
	tab_name.text = GameData.ITEM_TAB_NAMES[index]
	FilterButtons[index].button_pressed = true
	current_tab = index

	load_items(index)

func _on_item_window_opened() -> void:
	if not visible:
		return

	is_item_window_opened = true

	set_process(false)

func _on_item_window_closed() -> void:
	if not visible:
		return

	is_item_window_opened = false

	set_process(true)

	# select the previously selected item
	items_container_children[selected_index].select()	

# --- making inventory tab ---
func make_inventory() -> void:
	for key in GameData.ITEM_TAB_NAMES.keys():
		var button = Button.new()
		button.name = GameData.ITEM_TAB_NAMES[key] + "Button"
		
		# make them look good
		if TAB_ICONS.has(GameData.ITEM_TAB_NAMES[key]):
			button.icon = TAB_ICONS[GameData.ITEM_TAB_NAMES[key]]
		else:
			button.icon = PlaceholderTexture2D.new()
			button.icon.size = Vector2(16, 24)

		# load main theme
		button.theme = load(DirectoryPaths.main_theme)

		button.toggle_mode = true
		button.focus_mode = FOCUS_NONE

		# Remove borders from main theme, except for pressed
		var theme_ref = load(DirectoryPaths.main_theme)
		var style_normal = theme_ref.get_stylebox("normal", "Button").duplicate()
		style_normal.set_border_width_all(0)
		button.add_theme_stylebox_override("normal", style_normal)
		
		var style_hover = theme_ref.get_stylebox("hover", "Button").duplicate()
		style_hover.set_border_width_all(0)
		button.add_theme_stylebox_override("hover", style_hover)

		var style_disabled = theme_ref.get_stylebox("disabled", "Button").duplicate()
		style_disabled.set_border_width_all(0)
		button.add_theme_stylebox_override("disabled", style_disabled)

		filter_container.add_child(button)

func connect_filter_buttons() -> void:
	for child in filter_container.get_children():
		FilterButtons.append(child)

	for i in range(FilterButtons.size()):
		FilterButtons[i].pressed.connect(func():
			_on_filter_button_pressed(i)
		)

# --- loading inventory items ---
func load_items(index: int) -> void:
	items_container_children = []
	var inventory_comp: InventoryComponent = GameData.player.InventoryComp
	var items = inventory_comp.get_items(index)

	for item in items:
		var _inventory_item: InventoryItemControlNode = load(DirectoryPaths.inventory_item).instantiate()
		_inventory_item.init(item)
		items_container_children.append(_inventory_item)
		items_container.add_child(_inventory_item)
	
	if items_container_children.is_empty():
		return
	
	# select first item
	selected_index = 0
	items_container_children[selected_index].select()


	
func clear_items() -> void:
	for child in items_container.get_children():
		items_container.remove_child(child)
		child.queue_free()

func _update() -> void:
	clear_items()
	load_items(current_tab)



# --- EQUIPMENT PART ---

@onready var equipment_tab: EquipmentTabControlNode = $EquipmentTab
