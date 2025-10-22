class_name ItemWindowComponent
extends ItemComponent

var interaction_options_butons: Array[Button]


func open_item_window(_item: ItemResource) -> void:
	SignalBus.item_window_opened.emit()
	make_item_window(_item)

## makes the item window node
func make_item_window(_item: ItemResource) -> void:
	var item_window = load(DirectoryPaths.item_window_scene).instantiate()
	item_window._init_values(_item)
	GameData.player.get_node("PlayerUI").add_child(item_window)
