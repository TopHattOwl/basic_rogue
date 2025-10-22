extends Control
## when pressing an inventory item it opens its item window
## flow:
	# inventory item is pressed -> call's item's ItemWindowComponent.open_item_window
	# item wondow component makes and adds item window node to scene
	# item window node initializes itself



@export var item_button: Button

var item_reference: ItemResource


## initilizes inventory item [br]
## connects button press method to inventory item on press [br]
## (opens item's item window on press)
func init(_item: ItemResource) -> void:
	item_button.text = _item.display_name
	item_reference = _item


	item_button.pressed.connect(_on_item_pressed.bind(item_reference))

func _ready() -> void:
	var parent_conatiner = get_parent()

	item_button.size.x = parent_conatiner.size.x


func _on_item_pressed(item: ItemResource) -> void:
	# open item's item window 
	var _item_window_component: ItemWindowComponent = item.get_component(ItemWindowComponent)
	_item_window_component.open_item_window(item)

	
	
	
	
