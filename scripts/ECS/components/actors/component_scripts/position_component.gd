class_name PositionComponent
extends Node

var grid_pos: Vector2i = Vector2i.ZERO:
    set(value):
        grid_pos = value.clamp(Vector2i.ZERO, Vector2i(GameData.MAP_SIZE.x - 1, GameData.MAP_SIZE.y -1))
