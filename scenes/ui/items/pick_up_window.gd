extends PopupMenu

var items = []


func add_items(items: Array):
    self.items = items
    render_pick_up_window()

func render_pick_up_window():
    for item in items:
        var item_name = ComponentRegistry.get_component(item, GameData.ComponentKeys.ITEM_IDENTITY).item_name
        add_item(item_name)