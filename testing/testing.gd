extends Control

@onready var item_list: ItemList = $ItemList
@onready var item_list_2: ItemList = $ItemList2

func _ready() -> void:


	var img = PlaceholderTexture2D.new()
	img. size = Vector2(16, 24)
	item_list.add_item("Test item", img)
	item_list.add_item("Test item 2", img)
	item_list.add_item("Test item 4", img)
	item_list.add_item("Test item 5", img)
	item_list.add_item("Test item 6", img)
	item_list.add_item("Test item 7", img)
	item_list.add_item("Test item 8", img)
	item_list.add_item("Test item 9", img)
	item_list.add_item("Test item 10", img)
	item_list.add_item("Test item 11", img)
	item_list.add_item("Test item 12", img)
	item_list.add_item("Test item 13", img)


	item_list_2.add_item("Test item", img)
	item_list_2.add_item("Test item 2", img)
	item_list_2.add_item("Test item 4", img)
	item_list_2.add_item("Test item 5", img)
	item_list_2.add_item("Test item 6", img)
	item_list_2.add_item("Test item 7", img)
	item_list_2.add_item("Test item 8", img)
	item_list_2.add_item("Test item 9", img)
	item_list_2.add_item("Test item 10", img)
	item_list_2.add_item("Test item 11", img)
	item_list_2.add_item("Test item 12", img)
	item_list_2.add_item("Test item 13", img)


	item_list.multi_selected.connect(_on_item_multi_selected)
	item_list_2.multi_selected.connect(_on_item_multi_selected_2)

	item_list.grab_focus()

	print("Is inside tree after grabbing focus: ", is_inside_tree())



	for index in item_list.get_item_count():
		print(index)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept_custom"):  # Press enter to test
		print("Visible items: ", item_list.item_count)
		print("ItemList visible: ", item_list.visible)
		print("ItemList size: ", item_list.size)
		print("ItemList global position: ", item_list.global_position)
	

func _on_item_multi_selected(index: int, selected: bool):
	# This function runs every time an item is toggled
	print("Item at index %s is now %s" % [index, "selected" if selected else "deselected"])



func _on_item_multi_selected_2(index: int, selected: bool):
	# This function runs every time an item is toggled
	print("Item at index %s is now %s" % [index, "selected" if selected else "deselected"])
