extends Camera2D


@export var zoom_increment = Vector2(0.1, 0.1)
@export var min_zoom = Vector2(0.5, 0.5)
@export var max_zoom = Vector2(1.5, 1.5)

@export var min_zoom_world_map = Vector2(0.5, 0.5)
@export var max_zoom_world_map = Vector2(1.0, 1.0)

func _process(_delta: float) -> void:

	if GameData.player.PlayerComp.is_in_world_map:
		if Input.is_action_just_released("scroll_up"):
			zoom = clamp(zoom, min_zoom_world_map, max_zoom_world_map) + zoom_increment

		if Input.is_action_just_released("scroll_down"):
			zoom = clamp(zoom, min_zoom_world_map, max_zoom_world_map) - zoom_increment

	else:
		if Input.is_action_just_released("scroll_up"):
			zoom = clamp(zoom, min_zoom, max_zoom) + zoom_increment

		if Input.is_action_just_released("scroll_down"):
			zoom = clamp(zoom, min_zoom, max_zoom) - zoom_increment
