extends Sprite2D

var target_pos: Vector2i = Vector2i.ZERO


func _process(_delta: float) -> void:


	if GameData.player.PlayerComp.is_in_world_map:
		global_position = MapFunction.to_world_pos(MapFunction.world_map_mouse_pos)
	else:
		global_position = MapFunction.to_world_pos(MapFunction.zoomed_in_mouse_pos)


func toggle_targeter() -> void:
	visible = !visible
	set_process(visible)