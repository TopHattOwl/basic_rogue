extends Control
## When hovering over a buff icon, show a tooltip

var buff: Buff = null
@export var sprite: TextureRect

@export var modifires_container: VBoxContainer

func _ready() -> void:

	# make tooltips ignore mouse events
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in get_children():
		child.mouse_filter = Control.MOUSE_FILTER_IGNORE

	

func set_data(_buff: Buff) -> void:
	buff = _buff
	sprite.texture = buff.buff_sprite

	fill_modifiers_container()

func fill_modifiers_container() -> void:
	for mod in buff.modifiers:
		var label = Label.new()
		label.custom_minimum_size = Vector2(0, 10)
		label.label_settings = LabelSettings.new()
		label.label_settings.font_size = 6
		var desc = ""

		match mod.operation:
			GameData.MODIFIER_OPERATION.ADD:
				desc = make_add_desc(mod)
			GameData.MODIFIER_OPERATION.MULTIPLY:
				desc = make_multiply_desc(mod)
			GameData.MODIFIER_OPERATION.OVERRIDE:
				desc = make_override_desc(mod)
			_:
				pass

		# match mod.target_component:
		#     GameData.ComponentKeys.MELEE_COMBAT:
		#         desc += str(mod.value)
		#     GameData.ComponentKeys.BLOCK:
		#         desc += str(mod.value)
		#     _:
		#         pass
		
		# match mod.target_stat:
		#     # only check damage min -> damage min and max go together 
		#     "damage_min":
		#         desc += " to damage"
		#     "damage_max":
		#         continue
		#     "block":
		#         pass
		#     _:
		#         pass
		if desc == "":
			continue
		
		label.text = desc

		modifires_container.add_child(label)

func make_add_desc(_mod: StatModifier) -> String:
	var _desc = "+ " + str(_mod.value)

	match _mod.target_stat:
		"damage_min":
			_desc += " to damage"

		# only check damage min -> damage min and max go together
		"damage_max":
			return ""
		_:
			pass

	return _desc


func make_multiply_desc(_mod: StatModifier) -> String:
	var _desc = ""

	return _desc

func make_override_desc(_mod: StatModifier) -> String:
	var _desc = "changes "

	match _mod.target_stat:
		"element":
			_desc += "element to "
			match int(_mod.value):
				GameData.ELEMENT.FIRE:
					_desc += "fire"
				GameData.ELEMENT.ICE:
					_desc += "ice"
				GameData.ELEMENT.LIGHTNING:
					_desc += "lightning"
				GameData.ELEMENT.BLOOD:
					_desc += "blood"
				GameData.ELEMENT.POISON:
					_desc += "poison"
		_:
			pass
	

	return _desc
