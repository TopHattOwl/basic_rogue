class_name EquipmentSlotControlNode
extends Control

@export var background_texture: TextureRect
@export var item_texture: TextureRect
@export var slot_button: Button
@export var slot_label: Label
var equipped_item: ItemResource
var debug: int = GameData.equipment_ui_debug

## From enum GameData.EQUIPMENT_SLOTS
@export var equipment_id: int = -1


func _ready() -> void:
	_set_label()
	fill_in_equipment()
	slot_button.pressed.connect(_on_slot_button_pressed)
	SignalBus.equipment_changed.connect(fill_in_equipment)


## Filles the slot with the item if slot is not empty
func fill_in_equipment(_data: Dictionary = {}) -> void:
	var equipment_comp: EquipmentComponent = GameData.player.EquipmentComp
	var item: ItemResource = equipment_comp.equipment[equipment_id]

	if not item:
		equipped_item = null
		item_texture.texture = null
		background_texture.visible = true

		return
	
	equipped_item = item
	item_texture.texture = item.sprite
	background_texture.visible = false

func _on_slot_button_pressed() -> void:
	if debug:
		print("[EquipmentSlotControlNode] slot button pressed")

	if not equipped_item:
		if debug:
			print("[EquipmentSlotControlNode] no item in this slot, doing nothing")
		return


	if debug:
		print("[EquipmentSlotControlNode] item: ", equipped_item.display_name)

	var item_window_comp: ItemWindowComponent = equipped_item.get_component(ItemWindowComponent)
	item_window_comp.open_item_window(equipped_item)



func _set_label() -> void:
	var _text: String = GameData.EQUIPMENT_SLOTS.keys()[equipment_id]
	
	_text = _text.capitalize()

	slot_label.text = _text