extends Camera2D

var player_look_pos_grid: Vector2i

var look_diff_from_player: Vector2i

func _process(_delta: float) -> void:
    position = GameData.player.position + MapFunction.to_world_pos(look_diff_from_player)
