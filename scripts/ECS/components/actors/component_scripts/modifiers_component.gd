class_name ModifiersComponent
extends Node

var melee_combat_modifiers: Array[StatModifier]
var block_modifiers: Array[StatModifier]
var stamina_modifiers: Array[StatModifier]


# temporary buffs that only last for x turns
# not implemented
# replace Variant with Buff class_name
var buffs: Array[Variant]

# buff format _____
# var buff = {
#     "buff": buff_object, # modifiers is an Array[StatModifier]
#     "duration": 5
# }


func _ready() -> void:
	SignalBus.player_acted.connect(_advance_buffs)

func add_modifier(mod: StatModifier) -> void:
	match mod.target_component:
		GameData.ComponentKeys.MELEE_COMBAT:
			add_melee_combat_modifier(mod)
		GameData.ComponentKeys.BLOCK:
			pass


func remove_modifier(mod: StatModifier) -> void:
	match mod.target_component:
		GameData.ComponentKeys.MELEE_COMBAT:
			remove_melee_combat_modifier(mod)
		GameData.ComponentKeys.BLOCK:
			pass

# --- MELEE COMBAT ---
func add_melee_combat_modifier(mod: StatModifier) -> void:
	melee_combat_modifiers.append(mod)
	if melee_combat_modifiers.size() > 1:
		melee_combat_modifiers.sort_custom(_sort_priority)

func remove_melee_combat_modifier(mod: StatModifier) -> void:
	melee_combat_modifiers.erase(mod)


# --- SORTING ---
func _sort_priority(a: StatModifier, b: StatModifier) -> bool:
	return a.operation < b.operation


# --- BUFFS & DEBUFFS ---

func add_buff(buff: Buff) -> void:
	var modifiers = buff.modifiers
	var duration = buff.duration

	for mod in modifiers:
		match  mod.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				add_melee_combat_modifier(mod)
			GameData.ComponentKeys.BLOCK:
				pass

	buffs.append({
		"buff": buff,
		"duration": duration
	})

	SignalBus.buff_added.emit(buff, get_parent().get_parent())

func remove_buff(buff_data: Dictionary) -> void:
	var modifiers = buff_data.buff.modifiers

	for mod in modifiers:
		match mod.target_component:
			GameData.ComponentKeys.MELEE_COMBAT:
				remove_melee_combat_modifier(mod)
			GameData.ComponentKeys.BLOCK:
				pass

	buffs.erase(buff_data)

	SignalBus.buff_removed.emit(buff_data.buff, get_parent().get_parent())

func _advance_buffs() -> void:
	for buff in buffs:
		buff.duration -= 1
		if buff.duration <= 0:
			remove_buff(buff)

		
