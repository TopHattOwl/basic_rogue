extends Control
## When hovering over a buff icon, show a tooltip

var buff: Buff = null
@export var sprite: TextureRect

@export var duration: Label
@export var modifires_container: VBoxContainer

func _ready() -> void:

    # make tooltips ignore mouse events
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    for child in get_children():
        child.mouse_filter = Control.MOUSE_FILTER_IGNORE


    # set buff duration
    

func set_data(_buff: Buff) -> void:
    buff = _buff
    sprite.texture = buff.buff_sprite

    fill_modifiers_container()

func fill_modifiers_container() -> void:
    for mod in buff.modifiers:
        var label = Label.new()
        label.custom_minimum_size = Vector2(0, 16)
        label.label_settings = LabelSettings.new()
        label.label_settings.font_size = 6
        var desc = ""

        match mod.operation:
            GameData.MODIFIER_OPERATION.ADD:
                desc = "+ "
            GameData.MODIFIER_OPERATION.MULTIPLY:
                desc = "x "
            GameData.MODIFIER_OPERATION.OVERRIDE:
                desc = "OVERRIDE"
            _:
                pass

        match mod.target_component:
            GameData.ComponentKeys.MELEE_COMBAT:
                desc += str(mod.value)
            GameData.ComponentKeys.BLOCK:
                desc += str(mod.value)
            _:
                pass
        
        match mod.target_stat:
            # only check damage min -> damage min and max go together 
            "damage_min":
                desc += " to damage"
            "damage_max":
                continue
            "block":
                pass
            _:
                pass
        
        label.text = desc

        modifires_container.add_child(label)