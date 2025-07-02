class_name WeaponTypeCondition
extends Condition


var required_weapon_type: int

func _init(weapon_type: int) -> void:
    required_weapon_type = weapon_type

func is_met(_entity: Node2D = null) -> bool:
    var entity_weapon_type = _entity.EquipmentComp.equipment[GameData.EQUIPMENT_SLOTS.MAIN_HAND].get_component(MeleeWeaponComponent).weapon_type
    return required_weapon_type == entity_weapon_type