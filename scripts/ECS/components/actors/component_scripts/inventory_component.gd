class_name InventoryComponent
extends Node


var inventory: Dictionary = {}

# var inventory = {
# 	GameData.ITEM_TYPES.WEAPON: [],
# 	GameData.ITEM_TYPES.RANGED_WEAPON: [],
# 	....
# }


# if 0 then no limit on number of items
# but one type can only be in inventory once -> stack limit
var inventory_tab_size: Dictionary = {}



func _ready() -> void:
	make_inventory()

## Makes inventory from GameData.ITEM_TYPES [br]
## Adding new item type -> add to ITEM_TYPES enum
func make_inventory():
	for key in GameData.ITEM_TAB_NAMES.keys():
		inventory[key] = []
		inventory_tab_size[key] = GameData.ITEM_TAB_SIZES[key]



func add_item(item: ItemResource) -> bool:
	var item_type = item.item_type
	var stackable_comp = item.get_component(StackableComponent)
	var is_stackable = stackable_comp and stackable_comp.is_stackable

	var tab = inventory[item_type]
	var tab_limit = inventory_tab_size[item_type]

	# --stackable item check
	if is_stackable:
		print("--stackable item--")
		for existing_item in tab:

			# if item is already in inventory add to stack
			if existing_item.uid == item.uid:
				print("item already in inventory")
				var existing_stack = existing_item.get_component(StackableComponent)

				# if there is space in stack for full item stack put it in inventory
				if existing_stack.count == existing_stack.max_stack_size:
					print("stack is full, can't pick up item")
					return false
				if stackable_comp.count <= (existing_stack.max_stack_size - existing_stack.count):
					print("enough space in stack")
					existing_stack.count += stackable_comp.count
				else:
					print("not enough space in stack -> set to max")
					existing_stack.count = existing_stack.max_stack_size
				return true
			
		# if item is not in inventory add it to inventory
		print("item not in inventory")
		var new_item = item.duplicate()

		# if more than max stack size set to max
		if new_item.get_component(StackableComponent).count > new_item.get_component(StackableComponent).max_stack_size:
			print("initial count is too high -> set to max")
			new_item.get_component(StackableComponent).count = new_item.get_component(StackableComponent).max_stack_size
		tab.append(new_item)
		return true
	
	# if not stackable just add it to correct tab if there is space
	else:
		print("--not stackable item--")
		if tab.size() == tab_limit:
			print("tab is full, can't pick up item")
			return false
		else:
			tab.append(item)
			return true

func get_items(index: int) -> Array:
	order_inventory_tab(index)

	return inventory[index]

func order_inventory_tab(index: int) -> void:
	var tab = inventory[index]
	tab.sort_custom(func(a, b): return a.uid > b.uid)
