class_name ItemWindowComponent
extends ItemComponent


var interaction_options_butons: Array[Button]


func open_item_window(_item: ItemResource) -> void:
	print("opening item window")

	match _item.item_type:
		GameData.ITEM_TYPES.WEAPON:
			ItemWindowMaker.make_weapon_item_window(_item)
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
			ItemWindowMaker.make_resource_item_window(_item)
		GameData.ITEM_TYPES.OTHER:
			pass


func fill_interaction_options(_item: ItemResource) -> void:
	match _item.item_type:
		GameData.ITEM_TYPES.WEAPON:
			ItemWindowMaker.make_weapon_item_interactions(_item)
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
			ItemWindowMaker.make_resource_item_interactions(_item)
		GameData.ITEM_TYPES.OTHER:
			pass
