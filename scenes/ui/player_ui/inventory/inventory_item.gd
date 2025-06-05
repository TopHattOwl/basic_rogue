extends Control

@export var item_button: Button

var item_reference: ItemResource


## initilizes inventory item [br]
## connects button press
func init(_item: ItemResource) -> void:
	item_button.text = _item.display_name
	item_reference = _item


	item_button.pressed.connect(_on_item_pressed.bind(item_reference))

func _ready() -> void:
	var parent_conatiner = get_parent()

	item_button.size.x = parent_conatiner.size.x

# TODO: make component: ItemUI -> it will be a control node where item sprite is, display name all tat shit and a list of buttons for actions to perfom on the item
# make these actions automatically depending on item type
# weapons you cna equip, potons use
func _on_item_pressed(item: ItemResource) -> void:
	print("item pressed: ", item.display_name)
