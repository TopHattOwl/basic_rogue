class_name ArmorComponent
extends ItemComponent

@export var armor: int = 0 
@export var resistances: Dictionary = {}

func on_equip(_item: ItemResource, _entity: Node2D) -> void:
	var defense: DefenseStatsComponent = ComponentRegistry.get_component(_entity, GameData.ComponentKeys.DEFENSE_STATS)
	if not defense:
		return
	
	defense.armor += armor

	for element in resistances.keys():
		defense.resistances[element] += resistances[element]
		

func on_unequip(_item: ItemResource, _entity: Node2D) -> void:
	var defense: DefenseStatsComponent = ComponentRegistry.get_component(_entity, GameData.ComponentKeys.DEFENSE_STATS)
	if not defense:
		return
	
	defense.armor -= armor

	for element in resistances.keys():
		defense.resistances[element] -= resistances[element]