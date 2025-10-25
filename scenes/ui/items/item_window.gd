class_name ItemWindowControlNode
extends Control

var DEBUG_MODE := true

@export var Sprite: Sprite2D

# holds the buttons for each avaliable interaction on the item
@export var InteractionsContainer: VBoxContainer
var interaction_buttons: Array[Button]

var current_item: ItemResource

@export var Description: RichTextLabel
@export var DataText: RichTextLabel
@export var Stack: Label
@export var value_label: Label

func _init_values(_item: ItemResource) -> void:
	current_item = _item
	clear_buttons()
	Sprite.texture = current_item.sprite
	make_interact_buttons()
	fill_description()
	fill_data_text()
	fill_value_label()
	add_stack_size()

func _ready() -> void:
	SignalBus.inventory_closed.connect(_on_inventory_closed)
	DataText.bbcode_enabled = true

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


func add_equip_button() -> void:

	# if item is already equipped, add unequip button
	var equipable_comp: EquipableComponent = current_item.get_component(EquipableComponent)
	if equipable_comp.equipped:
		add_unequip_button()
		return
	var button = Button.new()
	button.name = "EquipButton"
	button.text = "Equip"
	InteractionsContainer.add_child(button)
	interaction_buttons.append(button)

	if DEBUG_MODE:
		print("[ItemWindow] Created EquipButton: ", button)
	
	button.pressed.connect(_on_equip_pressed)

func add_unequip_button() -> void:
	var button = Button.new()
	button.name = "UnequipButton"
	button.text = "Unequip"
	InteractionsContainer.add_child(button)
	interaction_buttons.append(button)

	if DEBUG_MODE:
		print("[ItemWindow] Created UnequipButton: ", button)
	
	button.pressed.connect(_on_unequip_pressed)


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


# --- VISUAL ---

## Adds current stack / max stack size
func add_stack_size() -> void:
	var stackable_comp = current_item.get_component(StackableComponent)
	if stackable_comp.is_stackable:
		Stack.text = "{0}/{1}".format([stackable_comp.count, stackable_comp.max_stack_size])

func fill_description() -> void:
	Description.text = current_item.description

func fill_data_text() -> void:
	var _text = ""

	# item type text
	_text += GameData.ITEM_TYPES.keys()[current_item.item_type].capitalize()

	# -- melee weapon text
	if current_item.get_component(MeleeWeaponComponent):
		var melee_weapon_comp: MeleeWeaponComponent = current_item.get_component(MeleeWeaponComponent)

		# weapon subtype text
		_text += " | " + GameData.WEAPON_SUBTYPES.keys()[melee_weapon_comp.weapon_sub_type].capitalize()
		_text += "\nDamage: " + str(melee_weapon_comp.damage_min) + "-" + str(melee_weapon_comp.damage_max) 

	# -- armor text
	if current_item.get_component(ArmorComponent):
		var armor_comp: ArmorComponent = current_item.get_component(ArmorComponent)
		var equipable_comp: EquipableComponent = current_item.get_component(EquipableComponent)

		# add equipment slot text
		_text += " | " + GameData.EQUIPMENT_SLOTS.keys()[equipable_comp.equipment_slot].capitalize()

		# armor value text
		_text += "\nArmor: " + str(armor_comp.armor)
		
		# resistance text
		for element in armor_comp.resistances.keys():
			if armor_comp.resistances[element] > 0:
				var element_color = AnimationSystem._get_element_color(element)
				_text += "\n[color=" + element_color + "]" + GameData.ELEMENT.keys()[element].capitalize() + " Resistance: " + str(armor_comp.resistances[element]) + "[/color]"

	DataText.text = _text

func fill_value_label() -> void:
	value_label.text = str(current_item.value) + " Gold"

func add_uses_label() -> void:
	Stack.text = "{0}/{1}".format([current_item.get_component(PowderComponent).current_uses, current_item.get_component(PowderComponent).max_uses])

# --- BUTTON PRESS FUNCS ---

func _on_equip_pressed() -> void:
	var equipment_comp: EquipmentComponent = GameData.player.EquipmentComp
	var item_slot = current_item.get_component(EquipableComponent).equipment_slot
	equipment_comp.equip_item(current_item, item_slot)

	close_window()

	SignalBus.inventory_update.emit()
	SignalBus.make_turn_pass.emit()


func _on_unequip_pressed() -> void:
	var equipment_comp: EquipmentComponent = GameData.player.EquipmentComp
	var item_slot = current_item.get_component(EquipableComponent).equipment_slot
	equipment_comp.unequip_item(item_slot)

	close_window()

	SignalBus.inventory_update.emit()
	SignalBus.make_turn_pass.emit()

	close_window()

## using stuff does not pass turn
func _on_use_pressed() -> void:
	var can_use_item: bool = current_item.call_component_bool({
		"method_name": "can_use",
		"entity": GameData.player,
	})

	if not can_use_item:
		return
		
	var inventory_comp: InventoryComponent = GameData.player.InventoryComp
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
