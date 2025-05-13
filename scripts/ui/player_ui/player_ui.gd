extends CanvasLayer


@onready var message_log: RichTextLabel = $MessageLog
@onready var hp_bar: Label = $HPBar

# look
@onready var look_ui: TextureRect = $LookUI
var look_ui_side = 1 # 1 = right, -1 = left
var look_target_stuff = []

# var look_target_stuff[0] = {
#     "texture": Texture2D,
#     "description": String,
#     "name": String,
# }

func _process(_delta: float) -> void:
    hp_bar.text = "HP: %s/%s" % [ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).hp, ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).max_hp]


# message log
func log_message(message: String) -> void:
    var full_message = ">" + message + "\n"
    message_log.append_text(full_message)
    message_log.scroll_to_line(message_log.get_line_count()) # auto-scroll 



# look ui
func toggle_look_ui() -> void:
    look_ui.visible = !look_ui.visible

func flip_look_ui() -> void:
    if look_ui_side == -1:
        get_node("LookUI").position.x = 400
    else:
        get_node("LookUI").position.x = 80
    look_ui_side *= -1

func set_look_ui_texture(texture: Texture2D) -> void:
    look_ui.get_node("TargetTileTexture").texture = texture