extends CanvasLayer


@onready var message_log: RichTextLabel = $MessageLog
@onready var hp_bar: Label = $HPBar

func _process(_delta: float) -> void:
    hp_bar.text = "HP: %s/%s" % [ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).hp, ComponentRegistry.get_player_comp(GameData.ComponentKeys.HEALTH).max_hp]

func log_message(message: String) -> void:
    var full_message = ">" + message + "\n"
    message_log.append_text(full_message)
    message_log.scroll_to_line(message_log.get_line_count()) # auto-scroll 
