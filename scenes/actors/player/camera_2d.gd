extends Camera2D


@export var zoom_increment = Vector2(0.1, 0.1)
@export var min_zoom = Vector2(0.40, 0.4)
@export var max_zoom = Vector2(1.0, 1.0)

@export var min_zoom_world_map = Vector2(0.3, 0.3)
@export var max_zoom_world_map = Vector2(0.7, 0.7)

var can_zoom = true

func _ready() -> void:
	SignalBus.item_window_opened.connect(toggle_can_zoom)
	SignalBus.item_window_closed.connect(toggle_can_zoom)
	SignalBus.inventory_opened.connect(toggle_can_zoom)
	SignalBus.inventory_closed.connect(toggle_can_zoom)

func _process(_delta: float) -> void:

	if can_zoom:
		if GameData.player.PlayerComp.is_in_world_map:
			if Input.is_action_just_released("scroll_up"):
				zoom = clamp(zoom + zoom_increment, min_zoom_world_map, max_zoom_world_map) 

			if Input.is_action_just_released("scroll_down"):
				zoom = clamp(zoom - zoom_increment, min_zoom_world_map, max_zoom_world_map)
				
		else:
			if Input.is_action_just_released("scroll_up"):
				zoom = clamp(zoom + zoom_increment, min_zoom, max_zoom)

			if Input.is_action_just_released("scroll_down"):
				zoom = clamp(zoom - zoom_increment, min_zoom, max_zoom)

func toggle_can_zoom() -> void:
	can_zoom = !can_zoom