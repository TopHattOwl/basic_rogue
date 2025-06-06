extends Control

var DEFAULT_TAB: int = GameData.ITEM_TYPES.WEAPON

# item filter buttons
var FilterButtons: Array[Button]


@onready var filter_container = $FilterContainer
@onready var tab_name = $TabName

@onready var items_container = $ItemsContainer

var current_tab = DEFAULT_TAB


func toggle_inventory() -> void:
	visible = !visible

	set_process(visible)

	_on_filter_button_pressed(DEFAULT_TAB)


func _ready() -> void:

	make_inventory()
	connect_filter_buttons()

	_on_filter_button_pressed(DEFAULT_TAB)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_inventory_next_tab"):
		_on_filter_button_pressed((current_tab + 1) % GameData.ITEM_TAB_NAMES.size())

	if Input.is_action_just_pressed("ui_inventory_prev_tab"):
		if current_tab == 0:
			_on_filter_button_pressed(GameData.ITEM_TAB_NAMES.size() - 1)
		else:
			_on_filter_button_pressed((current_tab - 1) % GameData.ITEM_TAB_NAMES.size())


func _on_filter_button_pressed(index: int) -> void:
	clear_items()
	tab_name.text = GameData.ITEM_TAB_NAMES[index]
	FilterButtons[index].grab_focus()
	current_tab = index

	load_items(index)


# --- making inventory tab ---
func make_inventory() -> void:
	for key in GameData.ITEM_TAB_NAMES.keys():
		var button = Button.new()
		# button.text = GameData.ITEM_TAB_NAMES[key]
		button.name = GameData.ITEM_TAB_NAMES[key] + "Button"
		

		# make them look good
		button.icon = PlaceholderTexture2D.new()
		button.icon.size = Vector2(16, 24)
		filter_container.add_child(button)

func connect_filter_buttons() -> void:
	for child in filter_container.get_children():
		FilterButtons.append(child)
	for button in FilterButtons:
		button.pressed.connect(_on_filter_button_pressed.bind(FilterButtons.find(button)))

# --- loading inventory items ---
func load_items(index: int) -> void:
	var inventory_comp = GameData.player.InventoryComp
	var items = inventory_comp.get_items(index)

	for item in items:
		var _inventory_item = load(DirectoryPaths.inventory_item).instantiate()
		_inventory_item.init(item)
		items_container.add_child(_inventory_item)
	

	
func clear_items() -> void:
	for child in items_container.get_children():
		items_container.remove_child(child)
		child.queue_free()

