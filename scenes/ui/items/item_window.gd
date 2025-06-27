extends Control

var DEBUG_MODE := true

@export var Sprite: Sprite2D

# holds the buttons for each avaliable interaction on the item
@export var InteractionsContainer: VBoxContainer
var interaction_buttons: Array[Button]

var current_item: ItemResource

@export var Description: RichTextLabel
@export var Stack: Label

func _init_values(_item: ItemResource) -> void:
	current_item = _item
	clear_buttons()
	Sprite.texture = current_item.sprite
	make_interact_buttons()
	fill_description()
	add_stack_size()

func _ready() -> void:
	SignalBus.inventory_closed.connect(_on_inventory_closed)

func _process(_delta: float) -> void:
	if not visible:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()

func make_interact_buttons() -> void:
	if DEBUG_MODE:
		print("[ItemWindow] Creating buttons for item: ", current_item.uid)

	if current_item.get_component(EquipableComponent):
		add_equip_button()
	
	if current_item.get_component(PowderComponent):
		add_use_button()

	

	add_look_button()
	add_test_button()


func add_equip_button() -> void:
	var button = Button.new()
	button.name = "EquipButton"
	button.text = "Equip"
	InteractionsContainer.add_child(button)
	interaction_buttons.append(button)

	if DEBUG_MODE:
		print("[ItemWindow] Created EquipButton: ", button)
	
	button.pressed.connect(_on_equip_pressed)

func add_use_button() -> void:
	var button = Button.new()
	button.name = "UseButton"
	button.text = "Use"
	InteractionsContainer.add_child(button)
	interaction_buttons.append(button)

	if DEBUG_MODE:
		print("[ItemWindow] Created UseButton: ", button)
	
	button.pressed.connect(_on_use_pressed)


	# add uses label
	add_uses_label()

func add_look_button() -> void:
	pass

func add_test_button() -> void:
	pass


# --- VISUAL ---

## Adds current stack / max stack size
func add_stack_size() -> void:
	var stackable_comp = current_item.get_component(StackableComponent)
	if stackable_comp.is_stackable:
		Stack.text = "{0}/{1}".format([stackable_comp.count, stackable_comp.max_stack_size])

func fill_description() -> void:
	Description.text = current_item.description

func add_uses_label() -> void:
	Stack.text = "{0}/{1}".format([current_item.get_component(PowderComponent).current_uses, current_item.get_component(PowderComponent).max_uses])

# --- BUTTON PRESS FUNCS ---

func _on_equip_pressed() -> void:
	var equipment_comp = GameData.player.EquipmentComp
	var item_slot = current_item.get_component(EquipableComponent).equipment_slot
	equipment_comp.equip_item(current_item, item_slot)

	close_window()

	SignalBus.inventory_update.emit()
	SignalBus.make_turn_pass.emit()

## using stuff does not pass turn
func _on_use_pressed() -> void:
	var inventory_comp = GameData.player.InventoryComp
	inventory_comp.use_item(current_item)

	close_window()

	SignalBus.inventory_update.emit()


# --- MISC ---
func clear_buttons() -> void:
	for child in InteractionsContainer.get_children():
		if DEBUG_MODE:
			print("[ItemWindow] Removing button: ", child.name)
		child.queue_free()
	interaction_buttons.clear()

func _on_inventory_closed() -> void:
	for child in InteractionsContainer.get_children():
		child.queue_free()
	interaction_buttons.clear()
	current_item = null
	Sprite.texture = null
	queue_free()

func close_window() -> void:
	_on_inventory_closed()
	SignalBus.item_window_closed.emit()
