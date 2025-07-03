class_name WeaponTypeCondition
extends Condition


var required_weapon_type: int


## Weapon type is from GameData.WEAPON_TYPES
func _init(weapon_type: int) -> void:
	required_weapon_type = weapon_type

func is_met(_entity: Node2D = null) -> bool:
	var entity_main_hand = ComponentRegistry.get_component(_entity, GameData.ComponentKeys.EQUIPMENT).equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND]
	if not entity_main_hand:
		return false
	var entity_weapon_type = entity_main_hand.get_component(MeleeWeaponComponent).weapon_type
	return required_weapon_type == entity_weapon_type
