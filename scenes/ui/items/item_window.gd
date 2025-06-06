extends Control

@export var Sprite: Sprite2D

# holds the buttons for each avaliable interaction on the item
@export var InteractionsContainer: VBoxContainer
var interaction_buttons: Array[Button]

var current_item: ItemResource

func _init_values(_item: ItemResource) -> void:
	current_item = _item
	Sprite.texture = current_item.sprite
	make_interact_buttons()

func _ready() -> void:
	SignalBus.inventory_closed.connect(_on_inventory_closed)


func make_interact_buttons() -> void:
	for button in current_item.get_component(ItemWindowComponent).interaction_options_butons:
		InteractionsContainer.add_child(button.duplicate())
		# connect_button(button)
		interaction_buttons.append(button)

	for button in current_item.get_component(ItemWindowComponent).interaction_options_butons:
		connect_button(button)

func _on_inventory_closed() -> void:
	for child in InteractionsContainer.get_children():
		child.queue_free()
	interaction_buttons.clear()
	current_item = null
	Sprite.texture = null
	queue_free()


## Connects buttons to signal once they are added into scene
func connect_button(button: Button) -> void:
	match button.name:
		"EquipButton":
			print("connecting equip button")
			button.pressed.connect(func():
				SignalBus.equipment_changing.emit(current_item, current_item.get_component(EquipableComponent).equipment_slot)
			)
		_:
			pass
