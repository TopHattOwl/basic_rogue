extends Node
## This is where you set up the UI for the item window [br]
## differeent item types have different item window looks 
const ITEM_WINDOW_SCENE = preload(DirectoryPaths.item_window_scene)

# --- ITEM WINDOW MAKERS ---
func make_weapon_item_window(_item: ItemResource) -> void:
	print("damage: {0}-{1}".format([_item.get_component(MeleeWeaponComponent).damage_min, _item.get_component(MeleeWeaponComponent).damage_max]) )
	print("name:", _item.display_name)

	var item_window = ITEM_WINDOW_SCENE.instantiate()

	item_window._init_values(_item)

	GameData.player.get_node("PlayerUI").add_child(item_window)

func make_resource_item_window(_item: ItemResource) -> void:
	print("name:", _item.display_name)
	print("stack (current/max) {0}/{1}".format([_item.get_component(StackableComponent).count, _item.get_component(StackableComponent).max_stack_size]))

	var item_window = ITEM_WINDOW_SCENE.instantiate()

	item_window._init_values(_item)

# --- ITEM INTERACTIONS ---

## Just makes the buttons [br]
## does not connect onpress function -> that can only be done when buttons are added into scene
func make_weapon_item_interactions(_item: ItemResource) -> void:

	# equip button
	var equip_button = Button.new()
	equip_button.text = "Equip"
	equip_button.name = "EquipButton"

	# connect_button_with_signal(equip_button, "equipment_changing", _item)
	_item.get_component(ItemWindowComponent).interaction_options_butons.append(equip_button)

	# look button
	var look_button = Button.new()
	look_button.text = "Look"
	# toggle look ui and pass item's data to make look window

func make_resource_item_interactions(_item: ItemResource) -> void:
	pass


# --- HELPERS ---

# func connect_button_with_signal(button: Button, signal_name: String, item: ItemResource) -> void:
# 	match signal_name:
# 		"equipment_changing":
# 			var equip_callable = SignalBus.equipment_changing.emit.bind(item, item.get_component(EquipableComponent).equipment_slot)
# 			button.pressed.connect(equip_callable)

# 			button.pressed.connect(_test)

func _test() -> void:
	print("test")
