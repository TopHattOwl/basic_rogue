class_name InventoryComponent
extends Node

var inventory: Dictionary = {
	GameData.ITEM_TYPES.WEAPON: [],
	GameData.ITEM_TYPES.RANGED_WEAPON: [],
	GameData.ITEM_TYPES.SHIELD: [],
	GameData.ITEM_TYPES.ARMOR: [],
	GameData.ITEM_TYPES.POTION: [],
	GameData.ITEM_TYPES.POWDER: [],
	GameData.ITEM_TYPES.MONSTER_PART: [],
	GameData.ITEM_TYPES.ALCHEMY: [],
	GameData.ITEM_TYPES.RESOURCE: [],
	GameData.ITEM_TYPES.OTHER: []
}


# if 0 then no limit on number of items
# but one type can only be in inventory once -> stack limit
var inventory_tab_size: Dictionary ={
	GameData.ITEM_TYPES.WEAPON: 20,
	GameData.ITEM_TYPES.RANGED_WEAPON: 15,
	GameData.ITEM_TYPES.SHIELD: 15,
	GameData.ITEM_TYPES.ARMOR: 35,
	GameData.ITEM_TYPES.POTION: 0,
	GameData.ITEM_TYPES.POWDER: 0,
	GameData.ITEM_TYPES.MONSTER_PART: 0,
	GameData.ITEM_TYPES.ALCHEMY: 0,
	GameData.ITEM_TYPES.RESOURCE: 0,
	GameData.ITEM_TYPES.OTHER: 0
}


func initialize(d: Dictionary) -> void:
	pass


func add_item(item: ItemResource) -> void:
	var item_type = item.item_type
	var tab = inventory[item_type]
	var tab_limit = inventory_tab_size[item_type]

	var stackable_comp = item.get_component(StackableComponent)
	var is_stackable = stackable_comp and stackable_comp.is_stackable

	if is_stackable:
		
		for existing_item in tab:
			pass
			
	else:
		pass


# class_name InventoryComponent
# extends Node

# # Inventory storage with typed arrays
# var inventory: Dictionary = {
#     GameData.ITEM_TYPES.WEAPON: [],
#     GameData.ITEM_TYPES.RANGED_WEAPON: [],
#     # ... other types ...
# }

# # Tab size constraints
# var inventory_tab_size: Dictionary = {
#     GameData.ITEM_TYPES.WEAPON: 20,
#     # ... other types ...
# }

# # Adds an item to inventory, returns true if successful
# func add_item(item: ItemResource) -> bool:
#     var item_type = item.item_type
#     var tab = inventory[item_type]
#     var tab_size_limit = inventory_tab_size[item_type]
    
#     # Check if item is stackable
#     var stackable_component = item.get_component(StackableComponent)
#     var is_stackable = stackable_component and stackable_component.is_stackable
    
#     if is_stackable:
#         # Stackable item logic
#         for existing_item in tab:
#             if existing_item.uid == item.uid:
#                 var existing_stack = existing_item.get_component(StackableComponent)
#                 if existing_stack.count < existing_stack.max_stack_size:
#                     existing_stack.count += 1
#                     return true
        
#         # Add new stack if there's space
#         if tab_size_limit == 0 or tab.size() < tab_size_limit:
#             var new_item = item.duplicate()
#             var new_stack = new_item.get_component(StackableComponent)
#             new_stack.count = 1
#             tab.append(new_item)
#             return true
#     else:
#         # Non-stackable item logic
#         if tab_size_limit == 0 or tab.size() < tab_size_limit:
#             tab.append(item.duplicate())
#             return true
    
#     return false

# # Removes an item from inventory
# func remove_item(item: ItemResource) -> bool:
#     var item_type = item.item_type
#     var tab = inventory[item_type]
    
#     for i in range(tab.size()):
#         if tab[i].uid == item.uid:
#             var stackable_component = tab[i].get_component(StackableComponent)
#             if stackable_component and stackable_component.is_stackable:
#                 stackable_component.count -= 1
#                 if stackable_component.count <= 0:
#                     tab.remove_at(i)
#                 return true
#             else:
#                 tab.remove_at(i)
#                 return true
#     return false

# # Gets all items of a specific type
# func get_items_of_type(item_type: int) -> Array:
#     return inventory.get(item_type, [])

# # Initialization remains the same
# func initialize(d: Dictionary) -> void:
#     pass
# ____________________________


# inventory ui implementation

# extends Control

# @onready var grid_container = $ScrollContainer/GridContainer
# @onready var item_preview = $ItemPreview

# var current_tab: int = GameData.ITEM_TYPES.WEAPON
# var player_inventory: InventoryComponent

# func _ready():
#     # Get player inventory (adjust based on your architecture)
#     player_inventory = EntitySystems.player.get_component(InventoryComponent)
    
#     # Connect filter buttons
#     for button in $FilterContainer.get_children():
#         button.pressed.connect(_on_filter_button_pressed.bind(button.get_index()))
    
#     # Load initial tab
#     load_tab_items(current_tab)

# # Load items for selected tab
# func load_tab_items(tab_type: int):
#     # Clear current grid
#     for child in grid_container.get_children():
#         child.queue_free()
    
#     # Get items for this tab
#     var items = player_inventory.get_items_of_type(tab_type)
    
#     # Create item buttons
#     for item in items:
#         var button = Button.new()
#         button.icon = item.sprite
#         button.tooltip_text = "%s\n%s" % [item.uid, item.description]
        
#         # Show stack count if stackable
#         var stackable = item.get_component(StackableComponent)
#         if stackable and stackable.is_stackable and stackable.count > 1:
#             button.text = str(stackable.count)
        
#         button.pressed.connect(_on_item_selected.bind(item))
#         grid_container.add_child(button)

# func _on_filter_button_pressed(index: int):
#     current_tab = index
#     load_tab_items(current_tab)

# func _on_item_selected(item: ItemResource):
#     # Show item details in preview panel
#     item_preview.display_item(item)
    
#     # For equipable items:
#     if item.get_component(MeleeWeaponComponent) or item.get_component(ArmorComponent):
#         $EquipButton.visible = true
#     else:
#         $EquipButton.visible = false

# func _on_equip_button_pressed():
#     var selected_item = item_preview.current_item
#     # Implement your equipment logic here
#     EquipmentSystem.equip_item(EntitySystems.player, selected_item)