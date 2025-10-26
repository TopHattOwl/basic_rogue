extends Control
## buff icon will get loaded into player's buff container

var buff: Buff
var buff_tooltip: Control
var buff_duration: int

@export var buff_icon: TextureRect
@export var  mouseover_area: Control # dont know what node this should be
@export var  duration: Label # dont know what node this should be


func _ready() -> void:
	mouseover_area.mouse_entered.connect(_on_mouse_entered)
	mouseover_area.mouse_exited.connect(_on_mouse_exited)

	SignalBus.turn_passed.connect(_on_player_acted)

func _on_player_acted() -> void:
	buff_duration -= 1
	duration.text = str(buff_duration)

func set_buff(_buff: Buff) -> void:
	buff = _buff

	buff_icon.texture = buff.buff_sprite
	buff_duration = _buff.duration
	duration.text = str(buff_duration)

func _on_mouse_entered() -> void:
	buff_tooltip = load(DirectoryPaths.buff_hover_tooltip_scene).instantiate()
	buff_tooltip.set_data(buff)

	buff_tooltip.position = self.position - Vector2(0, buff_tooltip.size.y + 30)

	

	GameData.player.PlayerUI.add_child(buff_tooltip)

	print("mouse entered")
	print("buff name: ", buff.buff_name)


func _on_mouse_exited() -> void:
	print("mouse exited")
	print("buff name: ", buff.buff_name)



	buff_tooltip.queue_free()
	buff_tooltip = null
