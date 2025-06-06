extends Control
## when pressing an inventory item it opens its item window
## flow:
	# ItemFactory fills in item's InventoryWindowComponent's interaction buttons
	# this node call's item's InventoryWindowComponent's open_item_window
	# item's InventoryWindowComponent calls the correct ItemWindowMaker
	# ItemWindowMaker load in ItemWindow scene and initializes item window's variables
	# ItemWindow scene connects the interact buttons based on item's item window component



@export var item_button: Button

var item_reference: ItemResource


## initilizes inventory item [br]
## connects button press method to inventory item on press [br]
## (opens item's item window on press)
func init(_item: ItemResource) -> void:
	item_button.text = _item.display_name
	item_reference = _item


	item_button.pressed.connect(_on_item_pressed.bind(item_reference))

	set_item_interactions()

func _ready() -> void:
	var parent_conatiner = get_parent()

	item_button.size.x = parent_conatiner.size.x


func _on_item_pressed(item: ItemResource) -> void:
	# open item's item window 
	item.get_component(ItemWindowComponent).open_item_window(item)


## sets item's ItemWinowComonent's interaction buttons
func set_item_interactions() -> void:
	var item_window_comp = item_reference.get_component(ItemWindowComponent)
	if !item_window_comp:
		push_error("item has no item window component")
		return
	var interaction = item_window_comp.interaction_options_butons


	# if interaction button are not made -> make them
	if interaction.size() > 0:
		print("interaction buttons filled")
	else:
		print("interaction buttons not filled")

		match item_reference.item_type:
			GameData.ITEM_TYPES.WEAPON:
				ItemWindowMaker.make_weapon_item_interactions(item_reference)
			GameData.ITEM_TYPES.RANGED_WEAPON:
				pass
			GameData.ITEM_TYPES.SHIELD:		
				pass
			GameData.ITEM_TYPES.ARMOR:
				pass
			GameData.ITEM_TYPES.POTION:
				pass
			GameData.ITEM_TYPES.POWDER:
				pass
			GameData.ITEM_TYPES.MONSTER_PART:
				pass
			GameData.ITEM_TYPES.ALCHEMY:
				pass
			GameData.ITEM_TYPES.RESOURCE:
				ItemWindowMaker.make_resource_item_interactions(item_reference)
			GameData.ITEM_TYPES.OTHER:
				pass
	
	
	
	
