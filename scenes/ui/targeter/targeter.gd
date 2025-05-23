extends Sprite2D

var target_pos: Vector2i = Vector2i.ZERO


func _process(_delta: float) -> void:
    position = MapFunction.to_world_pos(target_pos)



func toggle_targeter() -> void:
    visible = !visible