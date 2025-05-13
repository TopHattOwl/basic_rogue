class_name ItemIdentityComponent
extends Node

var item_type: int = 0
var item_name: String = ""
var price: int = 0



func initialize(d: Dictionary) -> void:
    item_type = d.get("item_type", GameData.ITEM_TYPES.OTHER)
    item_name = d.get("item_name", "")
    price = d.get("price", 0)
