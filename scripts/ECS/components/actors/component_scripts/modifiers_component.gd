class_name ModifiersComponent
extends Node

var melee_combat_modifiers: Array[StatModifier]
var block_modifiers: Array[StatModifier]
var stamina_modifiers: Array[StatModifier]
var energy_modifiers: Array[StatModifier]


# temporary buffs that only last for x turns
# not implemented
# replace Variant with Buff class_name
var buffs: Array[Variant]

# buff format _____
# var buff = {
#     "buff": buff_object, # modifiers is an Array[StatModifier]
#     "duration": 5
# }
func initialize(_d: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	SignalBus.turn_passed.connect(_advance_buffs)

func add_modifier(mod: StatModifier) -> void:
	if GameData.modifiers_debug:
		print("[ModifiersComponent] checking modifier: ", mod)

	if melee_combat_modifiers.has(mod) or block_modifiers.has(mod) or stamina_modifiers.has(mod) or energy_modifiers.has(mod):
		if GameData.modifiers_debug:
			print("[ModifiersComponent] modifier already applied, not adding")
		return
	
	match mod.target_component:
		GameData.ComponentKeys.MELEE_COMBAT:
			if GameData.modifiers_debug:
				print("[ModifiersComponent] adding melee combat modifier")
			add_melee_combat_modifier(mod)
		GameData.ComponentKeys.BLOCK:
			if GameData.modifiers_debug:
				print("[ModifiersComponent] adding block modifier")
			add_block_modifier(mod)
		GameData.ComponentKeys.STAMINA:
			if GameData.modifiers_debug:
				print("[ModifiersComponent] adding stamina modifier")
			pass
		GameData.ComponentKeys.ENERGY:
			if GameData.modifiers_debug:
				print("[ModifiersComponent] adding energy modifier")
			add_energy_modifier(mod)


func remove_modifier(mod: StatModifier) -> void:
	match mod.target_component:
		GameData.ComponentKeys.MELEE_COMBAT:
			remove_melee_combat_modifier(mod)
		GameData.ComponentKeys.BLOCK:
			remove_block_modifier(mod)

# --- MELEE COMBAT ---
func add_melee_combat_modifier(mod: StatModifier) -> void:
	melee_combat_modifiers.append(mod)
	if melee_combat_modifiers.size() > 1:
		melee_combat_modifiers.sort_custom(_sort_priority)

func remove_melee_combat_modifier(mod: StatModifier) -> void:
	melee_combat_modifiers.erase(mod)


func add_block_modifier(mod: StatModifier) -> void:
	block_modifiers.append(mod)
	if block_modifiers.size() > 1:
		block_modifiers.sort_custom(_sort_priority)

func remove_block_modifier(mod: StatModifier) -> void:
	block_modifiers.erase(mod)

func add_energy_modifier(mod: StatModifier) -> void:
	energy_modifiers.append(mod)
	if energy_modifiers.size() > 1:
		energy_modifiers.sort_custom(_sort_priority)

func remove_energy_modifier(mod: StatModifier) -> void:
	energy_modifiers.erase(mod)

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

		
